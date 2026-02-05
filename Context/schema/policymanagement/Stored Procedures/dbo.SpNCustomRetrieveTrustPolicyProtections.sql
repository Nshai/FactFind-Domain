CREATE PROCEDURE [dbo].[SpNCustomRetrieveTrustPolicyProtections]
(
  @CRMContactId BIGINT,                            
  @TenantId bigint
)
As

DECLARE @PlanList TABLE (PolicyBusinessId bigint PRIMARY KEY)      
INSERT INTO @PlanList      
SELECT DISTINCT     
 PB.PolicyBusinessId
FROM                                
 policymanagement..TPolicyOwner PO WITH(NOLOCK) 
 JOIN PolicyManagement..TPolicyBusiness PB WITH(NOLOCK) ON PO.PolicyDetailId = PB.PolicyDetailId 
 JOIN PolicyManagement..TPolicyDetail PD WITH(NOLOCK) ON PD.PolicyDetailId = PB.PolicyDetailId         
 JOIN PolicyManagement..TPlanDescription PDS WITH(NOLOCK) ON PDS.PlanDescriptionId = PD.PlanDescriptionId    
 JOIN TRefPlanType2ProdSubType AS plan2ProdType WITH(NOLOCK) ON plan2ProdType.RefPlanType2ProdSubTypeId = PDS.RefPlanType2ProdSubTypeId  
 JOIN dbo.TRefPlanDiscriminator AS discriminator ON plan2ProdType.RefPlanDiscriminatorId = discriminator.RefPlanDiscriminatorId
 JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) On Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
 JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType <> 'Deleted'    

WHERE PB.IndigoClientId = @TenantId 
  and  PO.CRMContactId = @CRMContactId and discriminator.PlanDiscriminatorName in ('PersonalProtectionPlan', 'GeneralMedicalInsurancePlan', 'GroupProtectionPlan', 'ProtectionPlan')

SELECT
p.ProtectionId ProtectionId,
pb.PolicyBusinessId,
p.LifeCoverSumAssured,
p.TermValue,
p.CriticalIllnessSumAssured,
p.CriticalIllnessTermValue,
it.IndexTypeName,
p.PremiumLoading,
p.RenewalDate,
p.Exclusions,
p.WaitingPeriod,
b.RefPaymentBasisName PaymentBasis,
p.BenefitSummary
FROM @PlanList pb  
 JOIN policymanagement..TProtection p WITH(NOLOCK) ON p.PolicyBusinessId = pb.PolicyBusinessId
 LEFT JOIN policymanagement..TRefIndexType it ON it.RefIndexTypeId = p.IndexTypeId
 LEFT JOIN policymanagement..TRefPaymentBasis b ON b.RefPaymentBasisId = p.PaymentBasisId