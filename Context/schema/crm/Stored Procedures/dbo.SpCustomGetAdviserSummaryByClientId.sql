SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetAdviserSummaryByClientId]
@CRMContactId bigint
AS

DECLARE @AdviserId					bigint
		, @UserId					bigint
		, @LegalEntityIdentifier	varchar(64)
		, @GroupId					bigint
		, @DoesAdviserHasAddress	bit
		, @LegalEntityCrmContactId	bigint

SELECT 
	@AdviserId = CurrentAdviserCRMId 
FROM 
	CRM..TCRMContact 
WHERE 
	CRMContactId = @CRMContactId
	
SELECT 
	@UserId = UserId
FROM 
	administration..TUser u 
WHERE 
	u.CRMContactId = @AdviserId

-- check whether the current adviser has at least one address specified
SELECT 
	@DoesAdviserHasAddress = CASE 
								WHEN COUNT(*) = 0 
									THEN 0 
									ELSE 1 
								END
FROM 
	crm..TAddress addr
INNER JOIN 
	crm..TCRMContact crmc ON crmc.CRMContactId = addr.CRMContactId
WHERE 
	crmc.CRMContactId = @AdviserId
	
-- Get LE details
SELECT 
	@LegalEntityIdentifier = Identifier,
	@GroupId = GroupId
FROM 
	administration..FnGetLegalEntityForUser(@UserId)

-- get CrmContactId for the Legal Entity
SELECT 
	@LegalEntityCrmContactId = CrmContactId
FROM 
	administration..TGroup
WHERE
	GroupId = @GroupId

BEGIN
SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.CRMContactId AS [CRMContact!1!CRMContactId], 
	ISNULL(T1.LastName, '') AS [CRMContact!1!LastName], 
	ISNULL(T1.FirstName, '') AS [CRMContact!1!FirstName],
	Administration.dbo.FnGetGroupLogoForUser(U.UserId) AS [CRMContact!1!GroupImageLocation],
	NULL AS [Address!2!AddressId], 
	NULL AS [Address!2!CRMContactId], 
	NULL AS [Address!2!AddressStoreId], 
	NULL AS [Address!2!RefAddressTypeId], 
	NULL AS [Address!2!AddressTypeName], 
	NULL AS [Address!2!DefaultFg], 
	NULL AS [Contact!3!ContactId], 
	NULL AS [Contact!3!CRMContactId], 
	NULL AS [Contact!3!RefContactType], 
	NULL AS [Contact!3!Description], 
	NULL AS [Contact!3!Value], 
	NULL AS [Contact!3!DefaultFg], 
	NULL AS [AddressStore!4!AddressStoreId], 
	NULL AS [AddressStore!4!AddressLine1], 
	NULL AS [AddressStore!4!AddressLine2], 
	NULL AS [AddressStore!4!AddressLine3], 
	NULL AS [AddressStore!4!AddressLine4], 
	NULL AS [AddressStore!4!CityTown],
	NULL AS [AddressStore!4!Postcode],
	ISNULL(	@LegalEntityIdentifier, '') AS [CRMContact!1!Identifier]
FROM 
	TCRMContact T1
	JOIN Administration..TUser U ON U.CRMContactId = T1.CRMContactId
WHERE 
	(T1.CRMContactId = @AdviserId)

UNION ALL

SELECT
	2 AS Tag,
	1 AS Parent,
	@AdviserId, 
	NULL, 
	NULL, 
	NULL,
	T2.AddressId, 
	ISNULL(T2.CRMContactId, ''), 
	ISNULL(T2.AddressStoreId, ''), 
	T2.RefAddressTypeId, 
	ISNULL(T2.AddressTypeName, ''), 
	T2.DefaultFg, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL,
	NULL
FROM 
	TAddress T2
JOIN 
	TCRMContact T1 ON T1.CRMContactId = T2.CRMContactId
WHERE 
	(T1.CRMContactId = CASE 
							WHEN @DoesAdviserHasAddress = 1 
								THEN @AdviserId 
								ELSE @LegalEntityCrmContactId 
							END)

UNION ALL

SELECT
	3 AS Tag,
	1 AS Parent,
	@AdviserId, 
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	T2.ContactId, 
	T2.CRMContactId, 
	T2.RefContactType, 
	ISNULL(T2.Description, ''), 
	T2.Value, 
	T2.DefaultFg, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL,
	NULL
FROM 
	TContact T2
JOIN 
	TCRMContact T1 ON T2.CRMContactId = T1.CRMContactId
WHERE 
	(T1.CRMContactId = @AdviserId)

UNION ALL

SELECT
	4 AS Tag,
	2 AS Parent,
	@AdviserId, 
	NULL, 
	NULL, 
	NULL,
	T2.AddressId, 
	ISNULL(T2.CRMContactId, ''), 
	ISNULL(T2.AddressStoreId, ''), 
	T2.RefAddressTypeId, 
	ISNULL(T2.AddressTypeName, ''), 
	T2.DefaultFg, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	T3.AddressStoreId, 
	ISNULL(T3.AddressLine1, ''), 
	ISNULL(T3.AddressLine2, ''), 
	ISNULL(T3.AddressLine3, ''), 
	ISNULL(T3.AddressLine4, ''), 
	ISNULL(T3.CityTown, ''), 
	ISNULL(T3.Postcode, ''),
	NULL
FROM 
	TAddressStore T3
JOIN 
	TAddress T2 ON T2.AddressStoreId = T3.AddressStoreId
JOIN 
	TCRMContact T1 ON T1.CRMContactId = T2.CRMContactId
WHERE 
	(T1.CRMContactId = CASE 
							WHEN @DoesAdviserHasAddress = 1 
								THEN @AdviserId 
								ELSE @LegalEntityCrmContactId 
							END)
ORDER BY 
	[CRMContact!1!CRMContactId], [Contact!3!ContactId], [Address!2!AddressId], [AddressStore!4!AddressStoreId]

FOR XML EXPLICIT

END

GO
