SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveWrapPlans]
(@crmContactId bigint,@crmContactId2 bigint)
AS  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SELECT Distinct 
 (crm.CorporateName +' '+ ISNULL(PB.PolicyNumber,'')) AS [Name],
 PB.PolicyBusinessId AS  PlanId
FROM TPolicyBusiness PB 
INNER JOIN TPolicyDetail PD
ON PB.PolicyDetailId = PD.PolicyDetailId
INNER JOIN TPolicyOwner PO
ON PD.PolicyDetailId = PO.PolicyDetailId
INNER JOIN TPlanDescription PDes
ON PDes.PlanDescriptionId = PD.PlanDescriptionId
INNER JOIN TRefPlanType2ProdSubType PT2PS
ON PT2PS.RefPlanType2ProdSubTypeId = PDes.RefPlanType2ProdSubTypeId
INNER JOIN TRefPlanType PT
ON PT.RefPlanTypeId = PT2PS.RefPlanTypeId
INNER JOIN TRefProdProvider PP
ON PP.RefProdProviderId = PDes.RefProdProviderId
INNER JOIN crm..TCRMContact crm
ON crm.CRMContactId = PP.CRMContactId
INNER JOIN policymanagement..TStatusHistory sh
ON sh.PolicyBusinessId = Pb.PolicyBusinessId
INNER JOIN policymanagement..TStatus s
ON s.StatusId = sh.StatusId
WHERE PT.IsWrapperFg = 1
AND PlanTypeName = 'Wrap'
AND PT2PS.IsArchived = 0
AND (PO.CRMContactId = @crmContactId OR PO.CRMContactId = @crmContactId2)
AND (s.IntelligentOfficeStatusType = 'In force' OR s.IntelligentOfficeStatusType = 'Paid Up')   AND sh.CurrentStatusFG = 1

  
FOR XML RAW('WrapPlan')  
GO








