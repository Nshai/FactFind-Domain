SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[nio_SearchContactTypeBy_TN_TT]    
@TenantId BIGINT,
@Name VARCHAR (50),
@TypeId VARCHAR(50) = NULL,
@_UserId BIGINT,
@IncludeDeleted BIT = 0
AS 

-- Check if the current user is a superuser or superviewer and adjust the 
-- @_UserId accordingly (negate the value to override security)
IF @_UserId !=  -1
BEGIN
SELECT  
 @_UserId =   
  CASE   
   WHEN (SuperUser = 1 OR SuperViewer = 1) THEN @_UserId*-1  
   ELSE @_UserId  
  END  
FROM  
 Administration.dbo.TUser  
WHERE  
 UserId = @_UserId  
END

BEGIN
SELECT 
	T1.CRMContactId AS PartyId,
	ISNULL(T1.CurrentAdviserName, '') AS CurrentAdviserName,
	ISNULL(T1.CorporateName, '') AS [Name],
    ISNULL(T1.PostCode, '') AS PostCode,  
	T2.StatusName AS ContactStatus,
	T4.RefTrustTypeId AS TypeId,
	T4.TrustTypeName AS [Type],
	ISNULL(T6.AddressLine1, '') AS AddressLine1,
	T1.[DOB],
	T1.MigrationRef AS ExternalId,
	CAST(T1.ArchiveFg as bit) as IsDeleted

FROM TCRMContact T1
	-- Client Status
	INNER JOIN TRefCRMContactStatus T2 
			ON T1.RefCRMContactStatusId = T2.RefCRMContactStatusId
	INNER JOIN TTrust T3
		ON T3.TrustId = T1.TrustId
	LEFT JOIN TRefTrustType T4
		ON T4.RefTrustTypeId = T3.RefTrustTypeId
	LEFT JOIN CRM.dbo.TAddress T5 
		ON T5.CRMContactId = T1.CRMContactId 
		AND T5.DefaultFG = 1
	LEFT JOIN CRM.dbo.TAddressStore T6 
		ON T6.AddressStoreId = T5.AddressStoreId		

	-- Secure clause for CRMContact
	LEFT JOIN VwCRMContactKeyByCreatorId TCKey 
			ON TCKey.UserId = ABS(@_UserId) AND TCKey.CreatorId = T1._OwnerId
	LEFT JOIN VwCRMContactKeyByEntityId TEKey 
			ON TEKey.UserId = ABS(@_UserId) AND TEKey.EntityId = T1.CRMContactId
			
	-- Secure clause for Lead
	LEFT JOIN VwLeadKeyByCreatorId TLCKey 
			ON TLCKey.UserId = ABS(@_UserId) AND TLCKey.CreatorId = T1._OwnerId
	LEFT JOIN VwLeadKeyByEntityId TLEKey 
			ON TLEKey.UserId = ABS(@_UserId) AND TLEKey.EntityId = T1.CRMContactId


WHERE	(T1.IndClientId = @TenantId) 
		 AND (  
				(@IncludeDeleted =0 AND T1.ArchiveFG=@IncludeDeleted)  
				OR   
				(@IncludeDeleted =1 AND T1.ArchiveFG IN (0,1) )  
			)
		AND (T1.CRMContactType = 2) 
		AND (T1.CorporateName LIKE '%' + @Name + '%')
		AND (@TypeId IS NULL OR T3.RefTrustTypeId = @TypeId)    
        AND (@_UserId < 0 OR (T1._OwnerId=ABS(@_UserId) OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)
							OR (TLCKey.CreatorId IS NOT NULL OR TLEKey.EntityId IS NOT NULL)))  

ORDER BY T1.CRMContactID

END

GO
