SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier        Issue          Description
----        ---------       -------        -------------
20230505    Saumya Rajan    IOSE22-1695    User Search list displayed alphabetically

*/
CREATE PROCEDURE [dbo].[nio_Client_DialogSearch]
	@TenantId INT,  
	@UserId INT,
	@CorporateName varchar(255) = NULL,    
	@FirstName varchar(255) = NULL,    
	@LastName varchar(255) = NULL,     
	@PrimaryRef varchar(50) = NULL,    
	@SecondaryRef varchar(50) = NULL,    
	@IncludeDeleted bit = 0,    
	@AdviserCRMContactId INT = NULL,
	@ServiceStatusId INT = NULL,
	@SequentialRefType varchar(50) = NULL,
	@SequentialRef varchar(50) = NULL,
	@PolicyNumber varchar(50) = NULL,
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
-- Tidy Sequential Ref Reference.
------------------------------------------------------------	
IF @SequentialRefType IS NOT NULL AND @SequentialRef IS NOT NULL BEGIN	
	SET @SequentialRef = LTRIM(RTRIM(REPLACE(@SequentialRef, '%', '')))
	SET @SequentialRef = RIGHT(REPLICATE('0', 8) + @SequentialRef, 8)  

	IF @SequentialRefType = 'PlanIOBRef'  
		SET @SequentialRef = 'IOB' + @SequentialRef
	ELSE IF @SequentialRefType = 'FeeIOFRef'  
		SET @SequentialRef = 'IOF' + @SequentialRef
	ELSE IF @SequentialRefType= 'RetainerIORRef'  
		SET @SequentialRef = 'IOR' + @SequentialRef
END

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
	
IF (@SequentialRefType = 'PlanIOBRef' AND @SequentialRef IS NOT NULL) OR @PolicyNumber IS NOT NULL
	SET @Sql = @Sql + '
	JOIN PolicyManagement.dbo.TPolicyOwner PO ON PO.CRMContactId = C.CRMContactId
	JOIN PolicyManagement.dbo.TPolicyBusiness PB ON PB.PolicyDetailId = PO.PolicyDetailId'
	
IF (@SequentialRefType = 'FeeIOFRef' AND @SequentialRef IS NOT NULL)
	SET @Sql = @Sql + '
	JOIN PolicyManagement.dbo.TFeeRetainerOwner FRO ON FRO.CRMContactId = C.CRMContactId
	JOIN PolicyManagement.dbo.TFee F ON F.FeeId = FRO.FeeId AND F.SequentialRef = @SequentialRef'
	
IF (@SequentialRefType = 'RetainerIORRef' AND @SequentialRef IS NOT NULL)
	SET @Sql = @Sql + '
	JOIN PolicyManagement.dbo.TFeeRetainerOwner FRO ON FRO.CRMContactId = C.CRMContactId
	JOIN PolicyManagement.dbo.TRetainer R ON R.RetainerId = FRO.RetainerId AND R.SequentialRef = @SequentialRef'
	
IF @IsSuperUser = 0
	SET @Sql = @Sql + '
	-- Secure (we have two joins, one for ownership rights & one for specific user/role rights)
	LEFT JOIN VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = @UserId AND TCKey.CreatorId = C._OwnerId
	LEFT JOIN VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @UserId AND TEKey.EntityId = C.CRMContactId'

SET @Sql = @Sql + '
WHERE     
	C.IndClientId = @TenantId 
	AND C.RefCRMContactStatusId = 1'

IF @IsSuperUser = 0
	SET @Sql = @Sql + ' AND (C._OwnerId = @UserId OR TCKey.UserId IS NOT NULL OR TEKey.UserId IS NOT NULL)'
	
IF @CorporateName IS NOT NULL 
	SET @Sql = @Sql + ' AND C.CorporateName LIKE @CorporateName'	

IF @Firstname IS NOT NULL 
	SET @Sql = @Sql + ' AND C.FirstName LIKE @FirstName'	

IF @LastName IS NOT NULL 
	SET @Sql = @Sql + ' AND C.LastName LIKE @LastName'	

IF @PrimaryRef IS NOT NULL 
	SET @Sql = @Sql + ' AND C.ExternalReference LIKE @PrimaryRef'	

IF @SecondaryRef IS NOT NULL 
	SET @Sql = @Sql + ' AND C.AdditionalRef LIKE @SecondaryRef'	

SET @Sql = @Sql + ' AND ISNULL(C.ArchiveFg, 0) = ' + CAST(@IncludeDeleted AS char(1))
	
IF @AdviserCRMContactId IS NOT NULL	
	SET @Sql = @Sql + ' AND C.CurrentAdviserCRMId = @AdviserCRMContactId'
	
IF @ServiceStatusId IS NOT NULL
	SET @Sql = @Sql + ' AND C.RefServiceStatusId = @ServiceStatusId'
	
IF (@SequentialRefType = 'PlanIOBRef' AND @SequentialRef IS NOT NULL) 
	SET @Sql = @Sql + ' AND PB.SequentialRef LIKE @SequentialRef'

IF @PolicyNumber IS NOT NULL	
	SET @Sql = @Sql + ' AND PB.PolicyNumber LIKE @PolicyNumber'	  
	
-- Kill the search if a ref has been specified with no type	
IF @SequentialRefType IS NULL AND @SequentialRef IS NOT NULL
	SET	@Sql = @Sql + ' AND 1=2'

--exclude internal contacts
	SET	@Sql = @Sql + ' and ISNULL(C.InternalContactFg, 0) = 0'

--Sorting based on FirstName, Lastname    
	SET @Sql = @Sql + ' ORDER BY ISNULL(TRIM(C.CorporateName), TRIM(C.FirstName) + '' '' + TRIM(C.LastName))'   

EXEC sp_executesql @Sql, 
	N'@TenantId bigint, @UserId bigint, @CorporateName varchar(255), @Firstname varchar(255),    
	@LastName varchar(255), @PrimaryRef varchar(50), @SecondaryRef varchar(50), @IncludeDeleted bit = 0, 
	@AdviserCRMContactId bigint, @ServiceStatusId bigint,
	@SequentialRefType varchar(50),	@SequentialRef varchar(50), @PolicyNumber varchar(50),	@PostCode varchar(50)', 	
	@TenantId = @TenantId, @UserId = @UserId, @CorporateName = @CorporateName, @Firstname = @Firstname,    
	@LastName = @LastName, @PrimaryRef = @PrimaryRef, @SecondaryRef = @SecondaryRef, @IncludeDeleted = @IncludeDeleted, @AdviserCRMContactId = @AdviserCRMContactId,
	@ServiceStatusId = @ServiceStatusId, @SequentialRefType = @SequentialRefType, @SequentialRef = @SequentialRef, @PolicyNumber = @PolicyNumber,
	@PostCode = @PostCode
GO
