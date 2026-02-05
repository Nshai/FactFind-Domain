SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_SearchContactTypeBy_IDS
@TenantId BIGINT
,@Ids VARCHAR (100)
,@IncludeDeleted bit = 0
,@_UserId BIGINT

AS 

-- Check if the current user is a superuser or superviewer and adjust the 
-- @_UserId accordingly (negate the value to override security)
SELECT
	@_UserId = 
		CASE 
			WHEN (SuperUser = 1 OR SuperViewer = 1) THEN @_UserId * -1
			ELSE @_UserId
		END
FROM
	Administration.dbo.TUser
WHERE
	UserId = @_UserId

BEGIN
SELECT 
	c.CRMContactId AS PartyId,
	ISNULL(c.CurrentAdviserName, '') AS CurrentAdviserName,
	(ISNULL(c.FirstName, '') + ' ' + ISNULL(c.LastName, '')) as FullName,
	'' AS FirstName,
	'' AS LastName,
	c.ArchiveFg AS ArchiveFG,
	'' AS CorporateName,
	StatusName AS ContactStatus,
	DOB as DOB,
	ISNULL(ads.AddressLine1, '') AS AddressLine1,
	ads.Postcode AS PostCode

FROM TCRMContact c
LEFT JOIN CRM.dbo.TAddress a
ON a.CRMContactId = c.CRMContactId
AND a.DefaultFG = 1
LEFT JOIN CRM.dbo.TAddressStore ads
ON ads.AddressStoreId = a.AddressStoreId

-- Secure clause for CRMContact
LEFT JOIN VwCRMContactKeyByCreatorId TCKey 
ON TCKey.UserId = ABS(@_UserId)
AND TCKey.CreatorId = c._OwnerId
LEFT JOIN VwCRMContactKeyByEntityId TEKey 
ON TEKey.UserId = ABS(@_UserId)
AND TEKey.EntityId = c.CRMContactId

-- Secure clause for Lead
LEFT JOIN VwLeadKeyByCreatorId TLCKey 
ON TLCKey.UserId = ABS(@_UserId)
AND TLCKey.CreatorId = c._OwnerId
LEFT JOIN VwLeadKeyByEntityId TLEKey 
ON TLEKey.UserId = ABS(@_UserId)
AND TLEKey.EntityId = c.CRMContactId

-- Client Status
INNER JOIN TRefCRMContactStatus cs 
ON c.RefCRMContactStatusId = cs.RefCRMContactStatusId

WHERE (c.IndClientId = @TenantId) 
AND (  
	(@IncludeDeleted = 0 AND c.ArchiveFG = @IncludeDeleted)  
	OR (@IncludeDeleted = 1 AND c.ArchiveFG IN (0,1)) 
)
AND (c.CRMContactType = 1) 
AND c.CRMContactId IN (
	SELECT CONVERT(INT, Value)
	FROM policymanagement.dbo.FnSplit(@Ids, ',')
)
AND (
	@_UserId < 0 
	OR (
		c._OwnerId=ABS(@_UserId) 
		OR (
			TCKey.CreatorId IS NOT NULL 
			OR 
			TEKey.EntityId IS NOT NULL
		)
		OR (
			TLCKey.CreatorId IS NOT NULL 
			OR 
			TLEKey.EntityId IS NOT NULL
		)
	)
)
END

GO
