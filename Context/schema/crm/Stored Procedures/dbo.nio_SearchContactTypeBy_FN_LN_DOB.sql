SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_SearchContactTypeBy_FN_LN_DOB    
@TenantId BIGINT,
@LastName VARCHAR (50),
@FirstName VARCHAR(50) = NULL,
@DOB DATETIME,
@IncludeDeleted bit = 0,
@_UserId BIGINT

AS 

-- Check if the current user is a superuser or superviewer and adjust the 
-- @_UserId accordingly (negate the value to override security)
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

BEGIN
SELECT 
	T1.CRMContactId AS PartyId,
	ISNULL(T1.CurrentAdviserName, '') AS CurrentAdviserName,
	(ISNULL(T1.FirstName, '') + ' ' + ISNULL(T1.LastName, '')) as FullName,
	'' AS FirstName,
	'' AS LastName,
	T1.ArchiveFg AS ArchiveFG,
	'' AS CorporateName,
	StatusName AS ContactStatus,
	DOB as DOB,
	ISNULL(T4.AddressLine1, '') AS AddressLine1,
	T4.Postcode AS PostCode

FROM TCRMContact T1
	LEFT JOIN CRM.dbo.TAddress T3 ON T3.CRMContactId = T1.CRMContactId AND T3.DefaultFG = 1
	LEFT JOIN CRM.dbo.TAddressStore T4 ON T4.AddressStoreId = T3.AddressStoreId

	-- Secure clause for CRMContact
	LEFT JOIN VwCRMContactKeyByCreatorId TCKey 
			ON 
				TCKey.UserId = ABS(@_UserId) 			
				AND 
				TCKey.CreatorId = T1._OwnerId
	LEFT JOIN VwCRMContactKeyByEntityId TEKey 
			ON 
				TEKey.UserId = ABS(@_UserId) 
				AND
				TEKey.EntityId = T1.CRMContactId

	-- Secure clause for Lead
	LEFT JOIN VwLeadKeyByCreatorId TLCKey 
			ON 
				TLCKey.UserId = ABS(@_UserId) 			
				AND 
				TLCKey.CreatorId = T1._OwnerId
	LEFT JOIN VwLeadKeyByEntityId TLEKey 
			ON 
				TLEKey.UserId = ABS(@_UserId) 
				AND
				TLEKey.EntityId = T1.CRMContactId

	-- Client Status
	INNER JOIN TRefCRMContactStatus T2 
			ON T1.RefCRMContactStatusId = T2.RefCRMContactStatusId

WHERE	(T1.IndClientId = @TenantId) 
		AND (  
				(@IncludeDeleted =0 AND T1.ArchiveFG=@IncludeDeleted)  
				OR   
				(@IncludeDeleted =1 AND T1.ArchiveFG IN (0,1) )  
			)
		AND (T1.CRMContactType = 1) 
		AND ISNULL(T1.LastName,'') Like (Case When @LastName='' Then ISNULL(T1.LastName,'') Else ('%' + @LastName + '%') End)
		AND	(@FirstName IS NULL OR T1.FirstName LIKE '%' + @FirstName + '%')
		AND (@DOB IS NULL OR T1.DOB = @DOB)    
        AND (
				@_UserId < 0 
				OR 
				(
					T1._OwnerId=ABS(@_UserId) 
					OR 
					(
						TCKey.CreatorId IS NOT NULL 
						OR 
						TEKey.EntityId IS NOT NULL
					 )

					OR 
					(
						TLCKey.CreatorId IS NOT NULL 
						OR 
						TLEKey.EntityId IS NOT NULL
					 )
				)
			)
END

GO
