SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveRelationshipsBasicDetails]
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
		c.CRMContactId													AS [ContactId],
		CASE WHEN c.PersonId IS NOT NULL THEN 'Person' 
				WHEN c.CorporateId IS NOT NULL THEN 'Corporate'
				WHEN c.TrustId IS NOT NULL THEN 'Trust'	END				AS [ClientType],
		relType.RelationshipTypeName									AS [Relationship],
		p.FirstName														AS [FirstName],
		p.LastName														AS [LastName],
		p.MiddleName													AS [MiddleName],
		CASE WHEN c.CorporateId IS NOT NULL THEN c.CorporateName END	AS [CompanyName],
		CASE WHEN c.TrustId IS NOT NULL THEN trust.TrustName END		AS [TrustName],
		p.Title															AS [Title],
		rel.StartedAt													AS [DateAppointed],
		tc.Value														AS [PrimaryContact],
		NULL															AS [TypeOfBeneficiary],
		NULL															AS [GiftType],
		NULL															AS [GiftValue],
		NULL															AS [RelationshipToSettlor],
		NULL															AS [BindingLapsingDate]
	FROM TRelationship rel
		JOIN TCRMContact c ON rel.CRMContactToId = c.CRMContactId
		JOIN TRefRelationshipType relType ON relType.RefRelationshipTypeId = rel.RefRelTypeId
		
		JOIN policymanagement.dbo.FnSplit(@CRMContactIds, ',') parslist ON parslist.Value = rel.CRMContactFromId
		LEFT JOIN TPerson p ON p.PersonId = c.PersonId
		LEFT JOIN TContact tc ON tc.CRMContactId = rel.CRMContactToId AND tc.IndClientId = @TenantId AND tc.RefContactType = 'Business' AND tc.DefaultFg = 1 AND c.CorporateId IS NOT NULL
		LEFT JOIN TTrust trust ON trust.TrustId = c.TrustId
		
	WHERE rel.RefRelTypeId IN (@TrustToSettlerRelType, @TrustToTrusteeRelType)
		AND ISNULL(c.IsDeleted,0) = 0  AND ISNULL(c.ArchiveFg,0) = 0
		AND c.IndClientId = @TenantId


UNION

	SELECT
		c.CRMContactId													AS [ContactId],
		CASE WHEN c.PersonId IS NOT NULL THEN 'Person' 
				WHEN c.CorporateId IS NOT NULL THEN 'Corporate'
				WHEN c.TrustId IS NOT NULL THEN 'Trust'	END				AS [ClientType],
		ISNULL(relType.RelationshipTypeName, 'Beneficiary (of Trust)')	AS [Relationship],
		p.FirstName														AS [FirstName],
		p.LastName														AS [LastName],
		p.MiddleName													AS [MiddleName],
		CASE WHEN c.CorporateId IS NOT NULL THEN c.CorporateName END	AS [CompanyName],
		CASE WHEN c.TrustId IS NOT NULL THEN trust.TrustName END		AS [TrustName],
		p.Title															AS [Title],
		rel.StartedAt													AS [DateAppointed],
		tc.Value														AS [PrimaryContact],
		ben.Type														AS [TypeOfBeneficiary],
		CASE 
			WHEN ben.Amount IS NOT NULL THEN 'Amount' 
			WHEN ben.BeneficaryPercentage IS NOT NULL THEN 'Percentage' 
			END															AS [GiftType],
		ISNULL(ben.Amount, ben.BeneficaryPercentage)					AS [GiftValue],
		(
			SELECT STRING_AGG(benToSettlerRelationType.RelationshipTypeName, ', ')
			FROM TRelationship benToSettlerRelation  
		 	LEFT JOIN TRelationship settlerToTrustRelation 
				ON benToSettlerRelation.CRMContactFromId = ben.BeneficaryCRMContactId 
				AND benToSettlerRelation.CRMContactToId = settlerToTrustRelation.CRMContactToId
			LEFT JOIN TRefRelationshipType benToSettlerRelationType 
				ON benToSettlerRelation.RefRelCorrespondTypeId = benToSettlerRelationType.RefRelationshipTypeId
			WHERE settlerToTrustRelation.CRMContactFromId = ben.TrustId 
				AND settlerToTrustRelation.RefRelTypeId = @TrustToSettlerRelType
		)																AS [RelationshipToSettlor],
		ben.BindingLapsingDate											AS [BindingLapsingDate]
	FROM (SELECT * FROM TRelationship WHERE RefRelTypeId = @TrustToBeneficiaryRelType) rel
		FULL OUTER JOIN (
			SELECT b.CrmContactId AS TrustId,
					b.Amount,
					b.Type,
					b.BeneficaryPercentage,
					ISNULL(b.BeneficaryCRMContactId, pc.CRMContactId) AS BeneficaryCRMContactId,
					b.BindingLapsingDate
					FROM policymanagement.dbo.TPolicyBeneficary b
				LEFT JOIN TPersonalContact pc ON pc.PersonalContactId = b.BeneficiaryPersonalContactId
			WHERE ISNULL(IsArchived,0) = 0) ben 
		ON (rel.CRMContactToId = ben.BeneficaryCRMContactId) AND rel.CRMContactFromId = ben.TrustId 

		JOIN TCRMContact c ON c.CRMContactId = ISNULL(ben.BeneficaryCRMContactId, rel.CRMContactToId )
		JOIN policymanagement.dbo.FnSplit(@CRMContactIds, ',') parslist ON parslist.Value = ISNULL(ben.TrustId, rel.CRMContactFromId)
		LEFT JOIN TRefRelationshipType relType ON relType.RefRelationshipTypeId = rel.RefRelTypeId
		LEFT JOIN TPerson p ON p.PersonId = c.PersonId
		LEFT JOIN TContact tc ON tc.CRMContactId = rel.CRMContactToId AND tc.IndClientId = @TenantId AND tc.RefContactType = 'Business' AND tc.DefaultFg = 1 AND c.CorporateId IS NOT NULL
		LEFT JOIN TTrust trust ON trust.TrustId = c.TrustId
	WHERE 
		ISNULL(c.IsDeleted,0) = 0  AND ISNULL(c.ArchiveFg,0) = 0
		AND c.IndClientId = @TenantId

	ORDER BY c.CRMContactId

END


