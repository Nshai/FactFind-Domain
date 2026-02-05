SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_SearchAccountBy_AN_TYPE    
@TenantId BIGINT,
@AccountName VARCHAR (50),
@AccountType BIGINT = NULL,
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
	(ISNULL(T1.CorporateName, '')) as AccountName,
	T3.AccountTypeName AS AccountType,
	T1._OwnerId AS AccountOwner,
	T1.ExternalReference AS PrimaryRef,
	'Corporate' AS AccountNature

FROM TCRMContact T1
	-- Secure clause
	LEFT JOIN VwCRMContactKeyByCreatorId TCKey 
			ON TCKey.UserId = ABS(@_UserId) AND TCKey.CreatorId = T1._OwnerId
	LEFT JOIN VwCRMContactKeyByEntityId TEKey 
			ON TEKey.UserId = ABS(@_UserId) AND TEKey.EntityId = T1.CRMContactId

	-- Account
	INNER JOIN TAccount T2 
			ON T1.CRMContactId = T2.CRMContactId
	-- Account Type
	INNER JOIN TAccountType T3
			ON T3.AccountTypeId = T2.AccountTypeId

WHERE	(T1.IndClientId = @TenantId) 
		AND (T1.ArchiveFg = 0) 
		AND (T1.CRMContactType = 3) 
		AND	(@AccountName IS NULL OR T1.CorporateName LIKE '%' + @AccountName + '%')
		AND (@AccountType IS NULL OR T2.AccountTypeId = @AccountType)    
        AND (@_UserId < 0 OR (T1._OwnerId=ABS(@_UserId) OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))

UNION ALL

SELECT 
	T1.CRMContactId AS PartyId,
	(ISNULL(T1.FirstName, '') + ' ' + ISNULL(T1.LastName, '')) as AccountName,
	T3.AccountTypeName AS AccountType,
	T1._OwnerId AS AccountOwner,
	T1.ExternalReference AS PrimaryRef,
	'Individual' AS AccountNature

FROM TCRMContact T1
	-- Secure clause
	LEFT JOIN VwCRMContactKeyByCreatorId TCKey 
			ON TCKey.UserId = ABS(@_UserId) AND TCKey.CreatorId = T1._OwnerId
	LEFT JOIN VwCRMContactKeyByEntityId TEKey 
			ON TEKey.UserId = ABS(@_UserId) AND TEKey.EntityId = T1.CRMContactId

	-- Account
	INNER JOIN TAccount T2 
			ON T1.CRMContactId = T2.CRMContactId
	-- Account Type
	LEFT JOIN TAccountType T3
			ON T3.AccountTypeId = T2.AccountTypeId

WHERE	(T1.IndClientId = @TenantId) 
		AND (T1.ArchiveFg = 0) 
		AND (T1.CRMContactType = 1) 
		AND	(@AccountName IS NULL OR ISNULL(T1.FirstName,'') + ' ' +ISNULL(T1.LastName,'') Like '%' + @AccountName + '%')
		AND (@AccountType IS NULL OR T2.AccountTypeId = @AccountType)    
        AND (@_UserId < 0 OR (T1._OwnerId=ABS(@_UserId) OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))

END
GO
