SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Anton Karpeza
-- Create date: 20-01-2021
-- Description: get plan beneficiaries for client and client relationships
-- =============================================
CREATE PROCEDURE [dbo].[spGetRelationshipsPlanBeneficiaries]
    @contactId INT
AS
BEGIN

    SET NOCOUNT ON;

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SELECT
        rel.CRMContactFromId,
        rel.CRMContactToId,
        rel.RefRelTypeId,
        rel.RefRelCorrespondTypeId,
        tp.RelationshipTypeName AS RelationshipTypeNameFrom,
        tpc.RelationshipTypeName AS RelationshipTypeNameTo
    INTO #relationshipsFrom
    FROM crm..TRelationship rel
    INNER JOIN crm..TRefRelationshipType tp ON tp.RefRelationshipTypeId = rel.RefRelTypeId
    INNER JOIN crm..TRefRelationshipType tpc ON tpc.RefRelationshipTypeId = rel.RefRelCorrespondTypeId
    WHERE
        CRMContactFromId = @contactId

    SELECT
        CRMContactToId
    INTO #contactIds
    FROM #relationshipsFrom

    INSERT INTO #contactIds VALUES (@contactId)

    CREATE NONCLUSTERED INDEX IDX ON #contactIds (CRMContactToId)

    SELECT
        COALESCE(pb.BeneficaryCRMContactId, pb.BeneficiaryPersonalContactId) AS ContactId,
        pb.BeneficaryName AS BeneficiaryName,
        rpt.PlanTypeName,
        pb.RelationshipType AS RelationshipTypeName,
        po.CRMContactId AS PolicyOwnerContactId
    INTO #planBeneficiaries
    FROM TPolicyOwner po
    INNER JOIN TPolicyDetail pdt ON po.PolicyDetailId = pdt.PolicyDetailId
    INNER JOIN TPlanDescription pds ON pds.PlanDescriptionId = pdt.PlanDescriptionId
    INNER JOIN TRefPlanType2ProdSubType pst ON pst.RefPlanType2ProdSubTypeId = pds.RefPlanType2ProdSubTypeId
    INNER JOIN TRefPlanType rpt ON rpt.RefPlanTypeId = pst.RefPlanTypeId
    INNER JOIN TPolicyBeneficary pb ON pdt.PolicyDetailId = pb.PolicyDetailId
    INNER JOIN #contactIds cn ON cn.CRMContactToId = po.CRMContactId
    WHERE
        pb.IsArchived = 0
        AND pb.RelationshipType IS NOT NULL

    SELECT DISTINCT
        pb.ContactId,
        pb.BeneficiaryName,
        pb.PlanTypeName,
        pb.RelationshipTypeName,
        pb.PolicyOwnerContactId,
        rf.RelationshipTypeNameFrom AS PolicyOwnerRelationshipTypeName
    FROM #planBeneficiaries pb
    LEFT JOIN #relationshipsFrom rf ON rf.CRMContactToId = pb.PolicyOwnerContactId AND rf.CRMContactFromId = pb.ContactId AND rf.RelationshipTypeNameTo = pb.RelationshipTypeName

END