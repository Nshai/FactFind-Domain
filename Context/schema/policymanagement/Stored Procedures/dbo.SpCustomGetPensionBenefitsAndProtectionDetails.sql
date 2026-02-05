SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpCustomGetPensionBenefitsAndProtectionDetails]	
	@PartyId bigint,
	@RelatedPartyId bigint = null,
	@TenantId bigint,
	@PlanTypeDescription varchar(255)
AS	

--DECLARE @PartyId BIGINT = 4670733
--DECLARE @RelatedPartyId BIGINT = 4670731
--DECLARE @TenantId BIGINT = 10155
--DECLARE @PlanTypeDescription NVARCHAR(255) = 'Annuities'

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
		JOIN factfind..TRefPlanTypeToSection PTS WITH(NOLOCK) ON PTS.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId  
		JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) ON Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
		JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType <> 'Deleted'  
  WHERE po.CRMContactId in (@PartyId, @RelatedPartyId) and pd.IndigoClientId = @TenantId     
  AND  PTS.Section = @PlanTypeDescription
                         

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
	prot.InTrust,
	prot.ToWhom,
	prot.ReviewDate,
	apt.RefAnnuityPaymentTypeName					AnnuityPaymentType,
	PD.AssumedGrowthRatePercentage,
	PD.CapitalElement,

	pinfo.ProspectivePensionAtRetirement			ProspectivePensionAtRetirement,	
	pinfo.ProspectiveLumpSumAtRetirement			ProspectiveLumpSumAtRetirement,
	pinfo.ProspectivePensionAtRetirementLumpSumTaken ProspectivePensionAtRetirementLumpSumTaken,
	pinfo.EarlyRetirementFactorNotes				EarlyRetirementFactorConsiderations,	
	pinfo.DependantBenefits							DependantBenefits,
	pinfo.IndexationNotes							IndexationNotes,	
	pinfo.EnhancedTaxFreeCash						EnhancedTaxFreeCash,
	pinfo.GuaranteedAnnuityRate						GuaranteedAnnuityRateOrPension,
	pinfo.ApplicablePenalties						ApplicablePenalties,	
	pinfo.EfiLoyaltyTerminalBonus					EFILoyaltyTerminalBonus,
	pinfo.GuaranteedGrowthRate						GuaranteedGrowthRate,	
	pinfo.OptionsAvailableAtRetirement				RetirementOptions,
	pinfo.OtherBenefitsAndMaterialFeatures			BenefitsOrMaterialFeatures,		
	pbext.AdditionalNotes							AdditionalNotes,
	@PlanTypeDescription							PlanTypeSection,
	pinfo.ServiceBenefitSpouseEntitled				DeathInServiceSpousalBenefits,
	pinfo.DeathBenefit								DeathBenefits,
	pinfo.CashEquivalentTransferValue				CashEquivalentTransferValue,
	pinfo.TransferExpiryDate						TransferExpiryDate,
	pinfo.CrystallisationStatus						CrystallisationStatus,
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