SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SpCheckAccessToPlanIncludingRelationships]
	@ClientId INT,
	@PlanId INT,
	@PermissionType varchar(50) = 'readwrite',
	@TenantId INT = NULL
AS
BEGIN

IF(@PermissionType NOT IN ('read','readwrite'))
BEGIN
	SELECT 0
	RETURN 100
END

IF EXISTS
(
    SELECT 1
    FROM [policymanagement].[dbo].[TPolicyBusiness] AS [p]
    INNER JOIN [policymanagement].[dbo].[TPolicyDetail] AS [d] ON [d].[PolicyDetailId] = [p].[PolicyDetailId]
    LEFT JOIN [policymanagement].[dbo].[TPolicyOwner] AS [o] ON [o].[PolicyDetailId]  = [d].[PolicyDetailId]
    WHERE [p].[PolicyBusinessId] = @planId AND [o].[CRMContactId] = @clientId 
		AND (@TenantId IS NULL OR [p].[IndigoClientId] = @TenantId)
)
BEGIN
	SELECT 1
	RETURN 0
END

IF EXISTS
(
    SELECT 1 FROM [policymanagement].[dbo].[TPolicyBusiness] AS [p]
    INNER JOIN [policymanagement].[dbo].[TAdditionalOwner] AS [a] on [a].[PolicyBusinessId] = [p].[PolicyBusinessId]
    WHERE [p].[PolicyBusinessId] = @planId AND [a].[CRMContactId] = @clientId
		AND (@TenantId IS NULL OR [p].[IndigoClientId] = @TenantId)
)
BEGIN
	SELECT 1
	RETURN 0
END

IF(@PermissionType != 'read')
BEGIN
	SELECT 0
	RETURN 0
END

DECLARE @IsValid BIT = 0;

;With
Relations(ClientId) AS
(
	--Get all relationships client's permitted to view in pfp
	SELECT REL.CRMContactToId
	FROM CRM..TRelationship REL
	WHERE REL.CRMContactFromId = @ClientId AND REL.IncludeInPfp = 1 --Contact from id is the relationship viewing the private info (get all contacts where this clientId is contactfrom and includeinpfp is true
	UNION ALL
	SELECT @ClientId
),
--Identify all policies of related client ids
ClientPolicyDetail(PolicyDetailId, hasClient) AS --Get policy detail ids those clients or I have access to, indicate which ones are mine with a 1, otherwise, 0
(
	SELECT PO.PolicyDetailId, MAX(CASE WHEN PO.CRMContactId = @ClientId THEN 1 ELSE 0 END) as hasClient --Max seems to be handling inner join/group by issues
	FROM [policymanagement].[dbo].[TPolicyOwner] PO
		INNER JOIN Relations Rels ON Rels.ClientId = PO.CRMContactId
	GROUP BY PO.PolicyDetailId
),
--Limit policies ids to those that are not owned by non relations
PolicyDetail(PolicyDetailId, PlanDescriptionId) AS
(
	SELECT DISTINCT CPD.PolicyDetailId, PD.PlanDescriptionId --Get policy detail id and plan description id where the detail id is not in the 
	FROM ClientPolicyDetail CPD
		INNER JOIN [policymanagement].[dbo].[TPolicyDetail] PD ON CPD.PolicyDetailId = PD.PolicyDetailId
	WHERE CPD.PolicyDetailId NOT IN (
		--If a relation of a given client id has a plan that is also owned by a non relation, then that plan is filtered out with the "NOT IN" clause.
		--If a son is a relation of his mom, and his mome has a plan co-owned by a non relation of the son, then the plan is filtered out by the NOT IN clause.
		SELECT CPD.PolicyDetailId
		FROM ClientPolicyDetail CPD
			INNER JOIN [policymanagement].[dbo].[TPolicyOwner] PO ON PO.PolicyDetailId = CPD.PolicyDetailId
			LEFT JOIN Relations Rels ON Rels.ClientId = PO.CRMContactId
		WHERE CPD.hasClient = 0 AND Rels.ClientId IS NULL
	)
)

SELECT TOP 1 @IsValid=1 FROM policymanagement.dbo.TPolicyBusiness AS TPB INNER JOIN PolicyDetail AS PD ON TPB.PolicyDetailId = PD.PolicyDetailId
	WHERE TPB.PolicyBusinessId = @PlanId
		AND (@TenantId IS NULL OR TPB.[IndigoClientId] = @TenantId)

SELECT @IsValid
RETURN 0
END

GO