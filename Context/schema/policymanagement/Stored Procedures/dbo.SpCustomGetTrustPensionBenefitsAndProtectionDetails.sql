SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpCustomGetTrustPensionBenefitsAndProtectionDetails]	
	@PartyId bigint,
	@TenantId bigint
AS	

 DECLARE @PartyPlans TABLE 
( 
 PolicyBusinessId bigint not null,
 PolicyDetailId bigint not null
)

INSERT INTO @PartyPlans
 SELECT DISTINCT pb.PolicyBusinessId, pb.PolicyDetailId
 FROM 
  PolicyManagement..TPolicyOwner PO 
		JOIN  PolicyManagement..TPolicyDetail Pd WITH(NOLOCK) ON Pd.PolicyDetailId = po.PolicyDetailId
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
    PP.PolicyBusinessId,  
    B.PensionCommencementLumpSum,
	CASE B.PCLSPaidById -- No Ref Data available on DB as it's using a hardcoded value in NIO

		WHEN 1 THEN 'Originating Scheme'
		WHEN 2 THEN 'Receiving Scheme'
		ELSE null

	END AS PCLSPaidBy,
	B.GADMaximumIncomeLimit,
	B.GuaranteedMinimumIncome,
	B.GADCalculationDate,
	B.IsCapitalValueProtected,
	B.CapitalValueProtectedAmount,
	B.LumpSumDeathBenefitAmount,
	B.IsSpousesBenefit,
	B.SpousesOrDependentsPercentage,
	B.IsOverlap,
	B.GuaranteedPeriod,
	B.IsProportion,
	prot.ReviewDate,
	apt.RefAnnuityPaymentTypeName AnnuityPaymentType,
	PD.AssumedGrowthRatePercentage,
	PD.CapitalElement,

	pinfo.ProspectivePensionAtRetirement ProspectivePensionAtRetirement,	
	pinfo.ProspectiveLumpSumAtRetirement ProspectiveLumpSumAtRetirement,
	pinfo.ProspectivePensionAtRetirementLumpSumTaken ProspectivePensionAtRetirementLumpSumTaken,
	pinfo.EarlyRetirementFactorNotes EarlyRetirementFactorConsiderations,	
	pinfo.DependantBenefits DependantBenefits,
	pinfo.IndexationNotes IndexationNotes,	
	pinfo.EnhancedTaxFreeCash EnhancedTaxFreeCash,
	pinfo.GuaranteedAnnuityRate GuaranteedAnnuityRateOrPension,
	pinfo.ApplicablePenalties ApplicablePenalties,	
	pinfo.EfiLoyaltyTerminalBonus EFILoyaltyTerminalBonus,
	pinfo.GuaranteedGrowthRate GuaranteedGrowthRate,	
	pinfo.OptionsAvailableAtRetirement RetirementOptions,
	pinfo.OtherBenefitsAndMaterialFeatures BenefitsOrMaterialFeatures,		
	pbext.AdditionalNotes AdditionalNotes,
	pinfo.ServiceBenefitSpouseEntitled DeathInServiceSpousalBenefits,
	pinfo.DeathBenefit DeathBenefits,
	pinfo.CashEquivalentTransferValue CashEquivalentTransferValue,
	pinfo.TransferExpiryDate TransferExpiryDate,
	pinfo.CrystallisationStatus CrystallisationStatus,
	CASE B.IsPre75
		WHEN 0 THEN 'Post 75'
		WHEN 1 THEN 'Pre 75'
		ELSE null
	END AS PrePost75

FROM 
 @PartyPlans pp
 LEFT JOIN PolicyManagement..TProtection PROT WITH(NOLOCK) ON PROT.PolicyBusinessId = PP.PolicyBusinessId
 LEFT JOIN PolicyManagement..TAssuredLife AL WITH(NOLOCK) ON AL.ProtectionId = PROT.ProtectionId AND AL.PartyId = @PartyId
 LEFT JOIN PolicyManagement..TBenefit B WITH(NOLOCK) ON B.BenefitId = AL.BenefitId
 LEFT JOIN PolicyManagement..TPolicyDetail PD WITH(NOLOCK) ON pd.PolicyDetailId = PP.PolicyDetailId 
 LEFT JOIN policymanagement..TRefAnnuityPaymentType apt WITH(NOLOCK) ON apt.RefAnnuityPaymentTypeId = pd.RefAnnuityPaymentTypeId
 LEFT JOIN policymanagement..TPensionInfo pinfo WITH(NOLOCK) ON pinfo.PolicyBusinessId = pp.PolicyBusinessId
 JOIN policymanagement..TPolicyBusinessExt pbext WITH(NOLOCK) ON pbext.PolicyBusinessId = pp.PolicyBusinessId
GO