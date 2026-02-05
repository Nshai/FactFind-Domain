SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[SpRetrieveRelationshipsContacts]
	@CRMContactIds VARCHAR(8000),
	@TenantId bigint
AS

BEGIN

	DECLARE @TrustToSettlerRelType int;
	DECLARE @TrustToTrusteeRelType int;
	DECLARE @TrustToBeneficiaryRelType int;
	
	SELECT  @TrustToSettlerRelType = [RefRelationshipTypeId] 
	FROM [crm].[dbo].[TRefRelationshipType] 
	WHERE RelationshipTypeName = 'Settlor' AND AccountFg = 0 AND TrustFg = 1 AND PersonFg = 1 
	AND ArchiveFg = 0 AND CorporateFg = 1

	SELECT  @TrustToTrusteeRelType = [RefRelationshipTypeId] 
	FROM [crm].[dbo].[TRefRelationshipType] 
	WHERE RelationshipTypeName = 'Trustee' AND AccountFg = 0 AND TrustFg = 1 AND PersonFg = 1 
	AND ArchiveFg = 0 AND CorporateFg = 1

	SELECT  @TrustToBeneficiaryRelType = [RefRelationshipTypeId] 
	FROM [crm].[dbo].[TRefRelationshipType] 
	WHERE RelationshipTypeName = 'Beneficiary (of Trust)' AND AccountFg = 0 AND TrustFg = 1 AND PersonFg = 1 
	AND ArchiveFg = 0 AND CorporateFg = 1

	SELECT
	cont.ContactId,
	cont.CRMContactId							AS [ContactOwnerPartyId],
	CASE WHEN ISNULL(p.PersonId, 0) <> 0
				THEN CONCAT_WS(' ', c.FirstName, c.LastName) 
				ELSE c.CorporateName
		END										AS [ContactName],
	cont.Value,
	cont.RefContactType							AS [ContactDetailTypeName],
	cont.Description							AS [Note],
	cont.DefaultFg								AS [IsDefault]

	FROM TRelationship rel
	JOIN TCRMContact c ON rel.CRMContactToId = c.CRMContactId
	JOIN TContact cont ON cont.CRMContactId = rel.CRMContactToId
	JOIN policymanagement.dbo.FnSplit(@CRMContactIds, ',') parslist ON parslist.Value = rel.CRMContactFromId
	LEFT JOIN TPerson p ON p.PersonId = c.PersonId
	WHERE rel.RefRelTypeId IN (@TrustToSettlerRelType, @TrustToTrusteeRelType)
	AND c.IsDeleted = 0
	AND ISNULL(c.ArchiveFg, 0) = 0
	AND cont.IndClientId = @TenantId 

	UNION

	SELECT
	cont.ContactId,
	cont.CRMContactId							AS [ContactOwnerPartyId],
	CASE WHEN ISNULL(p.PersonId, 0) <> 0
				THEN CONCAT_WS(' ', c.FirstName, c.LastName) 
				ELSE c.CorporateName
		END										AS [ContactName],
	cont.Value,
	cont.RefContactType							AS [ContactDetailTypeName],
	cont.Description							AS [Note],
	cont.DefaultFg								AS [IsDefault]

	FROM (SELECT * FROM TRelationship WHERE RefRelTypeId = @TrustToBeneficiaryRelType) rel
	FULL OUTER JOIN (SELECT * FROM policymanagement.dbo.TPolicyBeneficary WHERE ISNULL(IsArchived,0) = 0) ben ON rel.CRMContactToId = ben.BeneficaryCRMContactId AND rel.CRMContactFromId = ben.CrmContactId 
	JOIN TCRMContact c ON c.CRMContactId = ISNULL(ben.BeneficaryCRMContactId, rel.CRMContactToId )
	JOIN policymanagement.dbo.FnSplit(@CRMContactIds, ',') parslist ON parslist.Value = ISNULL(ben.CrmContactId, rel.CRMContactFromId)
	JOIN TContact cont ON cont.CRMContactId = c.CRMContactId 
	LEFT JOIN TPerson p ON p.PersonId = c.PersonId
	WHERE 
	c.IsDeleted = 0
	AND ISNULL(c.ArchiveFg, 0) = 0
	AND cont.IndClientId = @TenantId 

	ORDER BY cont.CRMContactId 
END