CREATE PROCEDURE [dbo].[SpNCustomRetrievePolicyProtections] 
(
  @CRMContactId BIGINT,                            
  @CRMContactId2 BIGINT,                       
  @TenantId bigint
)
As

--DECLARE @CRMContactId BIGINT = 4670733
--DECLARE @CRMContactId2 BIGINT = 4670731
--DECLARE @TenantId BIGINT = 10155

DECLARE @PlanList TABLE (PolicyBusinessId bigint PRIMARY KEY, DetailId bigint, RefPlanType2ProdSubTypeId bigint)      
INSERT INTO @PlanList      
SELECT DISTINCT     
 PB.PolicyBusinessId, PB.PolicyDetailId, PDS.RefPlanType2ProdSubTypeId
FROM                                
 policymanagement..TPolicyOwner PO WITH(NOLOCK) 
 JOIN PolicyManagement..TPolicyBusiness PB WITH(NOLOCK) ON PO.PolicyDetailId = PB.PolicyDetailId 
 JOIN PolicyManagement..TPolicyDetail PD WITH(NOLOCK) ON PD.PolicyDetailId = PB.PolicyDetailId         
 JOIN PolicyManagement..TPlanDescription PDS WITH(NOLOCK) ON PDS.PlanDescriptionId = PD.PlanDescriptionId    
 JOIN factfind..TRefPlanTypeToSection PTS WITH(NOLOCK) ON PTS.RefPlanType2ProdSubTypeId = PDS.RefPlanType2ProdSubTypeId 
 JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) On Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
 JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType <> 'Deleted'    

WHERE PB.IndigoClientId = @TenantId 
  and  PO.CRMContactId IN (@CRMContactId, @CRMContactId2) and lower(PTS.Section) in ('protection', 'building and contents insurance')

SELECT
p.ProtectionId ProtectionId,
pb.PolicyBusinessId,
pb.RefPlanType2ProdSubTypeId ProductTypeId,
p.InTrust,
p.ToWhom,
p.LifeCoverSumAssured,
p.TermValue,
p.CriticalIllnessSumAssured,
p.CriticalIllnessTermValue,
it.IndexTypeName,
p.PercentOfPremiumToInvest,
p.PremiumLoading,
p.RenewalDate,
p.Exclusions,
p.WaitingPeriod,
b.RefPaymentBasisName PaymentBasis,
p.BenefitSummary,
CASE WHEN wpb.ParentPolicyBusinessId IS NOT NULL THEN policy.SequentialRef ELSE NULL END AS RelatedToProduct,
CASE WHEN wpb.ParentPolicyBusinessId IS NOT NULL THEN 1 ELSE 0 END AS HeldInSuper
FROM @PlanList pb  
JOIN policymanagement..TProtection p WITH(NOLOCK) ON p.PolicyBusinessId = pb.PolicyBusinessId
LEFT JOIN policymanagement..TRefIndexType it ON it.RefIndexTypeId = p.IndexTypeId
LEFT JOIN policymanagement..TRefPaymentBasis b ON b.RefPaymentBasisId = p.PaymentBasisId
LEFT JOIN policymanagement..TWrapperPolicyBusiness wpb ON wpb.PolicyBusinessId = pb.PolicyBusinessId
LEFT JOIN PolicyManagement.dbo.TPolicyBusiness policy ON policy.PolicyBusinessId = pb.PolicyBusinessId
