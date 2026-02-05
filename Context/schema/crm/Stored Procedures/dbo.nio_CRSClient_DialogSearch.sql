SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_CRSClient_DialogSearch]
	@TenantId bigint,  
	@UserId bigint,
	@FirstName varchar(255) = NULL,    
	@LastName varchar(255) = NULL,     
	@PrimaryRef varchar(50) = NULL,    
	@SecondaryRef varchar(50) = NULL,    
	@AdviserCRMContactId bigint = NULL,
	@ServiceStatusId bigint = NULL,
	@ContactRefType varchar(50) = NULL,
	@Contact varchar(50) = NULL,
	@Address1 varchar(50) = NULL,
	@PostCode varchar(50) = NULL	
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @Sql nvarchar(4000)
------------------------------------------------------------
-- SuperUser and SuperViewer processing 
------------------------------------------------------------
DECLARE @IsSuperUser bit = 0

SELECT @IsSuperUser = SuperUser | SuperViewer
FROM Administration..TUser 
WHERE UserId = @UserId AND IndigoClientId = @TenantId

------------------------------------------------------------
-- Build SQL Search on basis of inputs.
------------------------------------------------------------
SET @Sql = '      
SELECT TOP 260
	C.CRMContactId AS [PartyId],     
	ISNULL(C.CorporateName, C.FirstName + '' '' + C.LastName) AS [ClientFullName],   
	ISNULL(C.CorporateName, C.LastName) AS [LastOrCorporateName],    
	C.CurrentAdviserName AS [CurrentAdviserName],
	AddrS.AddressLine1 AS [AddressLine1],
	AddrS.Postcode AS [Postcode]
FROM     
	TCRMContact C '
	
-- If postcode has been selected then match on any addresses (default or not) that match that code
IF @PostCode IS NOT NULL
	SET @Sql = @Sql + '	  	
	JOIN TAddress Addr ON Addr.CRMContactId = C.CRMContactId
	JOIN TAddressStore AddrS ON AddrS.AddressStoreId = Addr.AddressStoreId AND AddrS.Postcode LIKE @Postcode'
-- No postcode - just return the default address for the client.	
ELSE
	SET @Sql = @Sql + '
	LEFT JOIN TAddress Addr ON Addr.CRMContactId = C.CRMContactId AND Addr.DefaultFg = 1
	LEFT JOIN TAddressStore AddrS ON AddrS.AddressStoreId = Addr.AddressStoreId'
	
IF (@ContactRefType IS NOT NULL AND @Contact IS NOT NULL)
	SET @Sql = @Sql + '
	JOIN TContact Cont ON Cont.CRMContactId = C.CRMContactId AND Cont.RefContactType = @ContactRefType'
		
IF @IsSuperUser = 0
	SET @Sql = @Sql + '
	-- Secure (we have two joins, one for ownership rights & one for specific user/role rights)
	LEFT JOIN VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = @UserId AND TCKey.CreatorId = C._OwnerId
	LEFT JOIN VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @UserId AND TEKey.EntityId = C.CRMContactId'

SET @Sql = @Sql + '
WHERE     
	C.IndClientId = @TenantId 
	AND C.RefCRMContactStatusId = 1
	AND ISNULL(C.ArchiveFg, 0) = 0'

IF @IsSuperUser = 0
	SET @Sql = @Sql + ' AND (C._OwnerId = @UserId OR TCKey.UserId IS NOT NULL OR TEKey.UserId IS NOT NULL)'
	
IF @Firstname IS NOT NULL 
	SET @Sql = @Sql + ' AND C.FirstName LIKE @FirstName'	

IF @LastName IS NOT NULL 
	SET @Sql = @Sql + ' AND C.LastName LIKE @LastName'	

IF @PrimaryRef IS NOT NULL 
	SET @Sql = @Sql + ' AND C.ExternalReference LIKE @PrimaryRef'	

IF @SecondaryRef IS NOT NULL 
	SET @Sql = @Sql + ' AND C.AdditionalRef LIKE @SecondaryRef'	
	
IF @AdviserCRMContactId IS NOT NULL	
	SET @Sql = @Sql + ' AND C.CurrentAdviserCRMId = @AdviserCRMContactId'
	
IF @ServiceStatusId IS NOT NULL
	SET @Sql = @Sql + ' AND C.RefServiceStatusId = @ServiceStatusId'
	
IF (@ContactRefType IS NOT NULL AND @Contact IS NOT NULL) 
	SET @Sql = @Sql + ' AND Cont.Value LIKE @Contact'

IF @Address1 IS NOT NULL	
	SET @Sql = @Sql + ' AND AddrS.AddressLine1 LIKE @Address1'	  
	
-- Kill the search if a ref has been specified with no value	
IF @ContactRefType IS NULL AND @Contact IS NOT NULL
	SET	@Sql = @Sql + ' AND 1=2'
	
	print @Sql
EXEC sp_executesql @Sql, 
	N'@TenantId bigint, @UserId bigint, @Firstname varchar(255),    
	@LastName varchar(255), @PrimaryRef varchar(50), @SecondaryRef varchar(50), 
	@AdviserCRMContactId bigint, @ServiceStatusId bigint,
	@ContactRefType varchar(50),	@Contact varchar(50), @Address1 varchar(50),	@PostCode varchar(50)', 	
	@TenantId = @TenantId, @UserId = @UserId, @Firstname = @Firstname,    
	@LastName = @LastName, @PrimaryRef = @PrimaryRef, @SecondaryRef = @SecondaryRef, @AdviserCRMContactId = @AdviserCRMContactId,
	@ServiceStatusId = @ServiceStatusId, @ContactRefType = @ContactRefType, @Contact = @Contact, @Address1 = @Address1,
	@PostCode = @PostCode
