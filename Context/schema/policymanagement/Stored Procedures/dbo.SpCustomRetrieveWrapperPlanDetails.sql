SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveWrapperPlanDetails]
	@CrmContactId1 bigint,
	@CrmContactId2 bigint,
	@RefPlanTypeId bigint,
	@TenantId bigint
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
-------------------------------------------------------
-- find plans for our fact find owners
-------------------------------------------------------
CREATE TABLE #PolicyDetails(PolicyDetailId bigint)

INSERT INTO #PolicyDetails(PolicyDetailId)
SELECT DISTINCT PolicyDetailId 
FROM policymanagement..TPolicyOwner 
WHERE CRMContactId IN (@CrmContactId1, @CrmContactId2)

-------------------------------------------------------
-- If it's a joint fact find remove any plans where there's
-- an owner which doesn't correspond to our fact finds
-------------------------------------------------------
IF ISNULL(@CrmContactId2, 0) > 0
	DELETE A
	FROM 
		#PolicyDetails A
		JOIN TPolicyOwner O ON O.PolicyDetailId = A.PolicyDetailId
	WHERE 
		O.CRMContactId NOT IN (@CrmContactId1, @CrmContactId2)

-------------------------------------------------------
-- Return wrapper plan information for our owners
-------------------------------------------------------
SELECT 
	pb.PolicyBusinessId as Id,
	pb.PolicyNumber,
	pro.CorporateName as [ProviderName]
FROM 
	PolicyManagement..TPolicyBusiness pb 
	JOIN PolicyManagement..TPolicyDetail pd1 on pb.PolicyDetailId=pd1.PolicyDetailId 
	JOIN #PolicyDetails po1 ON po1.PolicyDetailId = pd1.PolicyDetailId
	JOIN PolicyManagement..TPlanDescription pdes on pd1.PlanDescriptionId=pdes.PlanDescriptionId 
	JOIN PolicyManagement..TRefPlanType2ProdSubType rp2p on pdes.RefPlanType2ProdSubTypeId=rp2p.RefPlanType2ProdSubTypeId 
	JOIN PolicyManagement..TRefPlanType rpt on rp2p.RefPlanTypeId=rpt.RefPlanTypeId 
	JOIN PolicyManagement..TRefProdProvider rpro on pdes.RefProdProviderId=rpro.RefProdProviderId 
	JOIN crm.dbo.TCRMContact pro on rpro.CRMContactId = pro.CRMContactId
	JOIN PolicyManagement..TStatusHistory statushist on pb.PolicyBusinessId=statushist.PolicyBusinessId AND statushist.CurrentStatusFG = 1
	JOIN PolicyManagement..TStatus [status] on statushist.StatusId=[status].StatusId 
WHERE 
	rpt.IsWrapperFg = 1 
	AND pb.IndigoClientId = @TenantId
	AND rpt.RefPlanTypeId = @RefPlanTypeId 
	AND rp2p.IsArchived = 0 
	AND [status].IntelligentOfficeStatusType in ('In force', 'Paid Up')
GO
