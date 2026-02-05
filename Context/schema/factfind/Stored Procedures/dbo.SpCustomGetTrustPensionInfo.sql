SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetTrustPensionInfo]	
	@PartyId bigint,
	@TenantId bigint	
AS	
Begin

 DECLARE @PartyPlans TABLE 
( 
 PolicyBusinessId bigint not null
)

INSERT INTO @PartyPlans
 SELECT DISTINCT pb.PolicyBusinessId
 FROM 
  PolicyManagement..TPolicyOwner PO 
		JOIN PolicyManagement..TPolicyDetail Pd WITH(NOLOCK) ON Pd.PolicyDetailId = po.PolicyDetailId
		JOIN PolicyManagement..TPolicyBusiness Pb WITH(NOLOCK) ON Pb.PolicyDetailId = Pd.PolicyDetailId		
		JOIN PolicyManagement..TPlanDescription PDesc WITH(NOLOCK)  ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId   	
		JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) ON Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
		JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType <> 'Deleted'        
		JOIN PolicyManagement..TRefPlanType2ProdSubType AS plan2ProdType WITH(NOLOCK) ON plan2ProdType.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId  
		JOIN PolicyManagement..TRefPlanDiscriminator AS discriminator WITH(NOLOCK) ON plan2ProdType.RefPlanDiscriminatorId = discriminator.RefPlanDiscriminatorId

  WHERE po.CRMContactId = @PartyId and pd.IndigoClientId = @TenantId     
  AND discriminator.RefPlanDiscriminatorId IN (5, 6, 7) -- PensionDefinedBenefitPlan (5), PensionContributionDrawdownPlan (6), AnnuityPlan (7)
  AND plan2ProdType.RefPlanType2ProdSubTypeId NOT IN (60, 1113, 14, 1145) --Annuity (Non-Pension), Fixed Term Annuity and Trustee Investment Plan plantypes are not included in Retirments in TFF. Purchase Life Annuity is excluded from TFF existing product.

SELECT
 Pd.PolicyBusinessId,
 tpi.SRA as StandardRetirementAge,
 tpi.PensionableSalary,
 tpi.AccrualRate,
 tpi.ExpectedYearsOfService,
 tpi.LifetimeAllowanceUsed,
 tpi.EmployerContributionDetail,
 tpi.LifeStylingStrategyDetail 
FROM   
 @PartyPlans pd              
 LEFT JOIN PolicyManagement..TPensionInfo tpi WITH(NOLOCK) ON tpi.PolicyBusinessId = pd.PolicyBusinessId

End
GO
