CREATE PROCEDURE [dbo].[SpCustomGetTrustInvestments]	
	@PartyId bigint,
	@TenantId bigint	
AS

DECLARE @PartyPlans TABLE 
( 
 PolicyBusinessId bigint not null,
 RefPlanType2ProdSubTypeId bigint not null
)

INSERT INTO @PartyPlans
SELECT DISTINCT pb.PolicyBusinessId, plan2ProdType.RefPlanType2ProdSubTypeId
 FROM 
  PolicyManagement..TPolicyOwner PO 
		JOIN  PolicyManagement..TPolicyDetail Pd WITH(NOLOCK) ON Pd.PolicyDetailId = po.PolicyDetailId
		JOIN PolicyManagement..TPolicyBusiness Pb WITH(NOLOCK) ON Pb.PolicyDetailId = Pd.PolicyDetailId		
		JOIN PolicyManagement..TPlanDescription PDesc WITH(NOLOCK)  ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId   	

		JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) ON Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
		JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType <> 'Deleted'  
		
		JOIN TRefPlanType2ProdSubType AS plan2ProdType WITH(NOLOCK) ON plan2ProdType.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId  
		JOIN dbo.TRefPlanDiscriminator AS discriminator ON plan2ProdType.RefPlanDiscriminatorId = discriminator.RefPlanDiscriminatorId

		WHERE po.CRMContactId = @PartyId and pd.IndigoClientId = @TenantId
		AND (discriminator.PlanDiscriminatorName in  ('CashBankAccountPlan', 'LifeAssuredInvestmentPlan', 'InvestmentPlan') 
		OR plan2ProdType.RefPlanType2ProdSubTypeId in (60, 1113, 14)) --Annuity (Non-Pension) and Fixed Term Annuity plantypes are included in Investments in TFF

SELECT
 P.PolicyBusinessId,   
 Pb.LowMaturityValue,  
 Pb.MediumMaturityValue,  
 Pb.HighMaturityValue, 
 pb.ProjectionDetails,
 Pb.IsGuaranteedToProtectOriginalInvestment,
 CASE WHEN p.RefPlanType2ProdSubTypeId in (125, 79, 30, 1207, 1208) THEN ABS(pv.PlanValue) ELSE NULL END AS 'CurrentBalance',
 ext.InterestRate
FROM   

 @PartyPlans p       
 JOIN  PolicyManagement..TPolicyBusiness Pb WITH(NOLOCK) ON Pb.PolicyBusinessId = p.PolicyBusinessId      
 LEFT JOIN policymanagement..TPlanValuation pv ON PV.PlanValuationId = (SELECT TOP 1 PlanValuationId from policymanagement..TPlanValuation pv WHERE pv.PolicyBusinessId = p.PolicyBusinessId ORDER BY PlanValueDate DESC) 
 LEFT JOIN policymanagement..TPolicyBusinessExt ext ON Pb.PolicyBusinessId = ext.PolicyBusinessId