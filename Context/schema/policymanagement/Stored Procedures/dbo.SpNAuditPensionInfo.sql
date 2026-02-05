SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPensionInfo]
	@StampUser varchar (255),
	@PensionInfoId bigint,
	@StampAction char(1)
AS

INSERT INTO TPensionInfoAudit
( PolicyBusinessId, SRA, PensionableSalary, RefReturnDeathTypeId,
		ReturnOnDeathRate, ProtectedRightsOnly, QualifiesDSSIncentive, RefLifeCoverId,
		RebatePaid, ContributionUpdated, IsCurrent, RefSchemeSetUpId,
		HasWidowsPension, HasProtectionAgainstInflation, ProvidesTaxFreeLumpSum, ContractedOutOfS2P,
		ExpectedYearsOfService, NumberOfYearsCompleted, IsIndexed, RefSchemeBasisId,
		FinalSalary, RefContributionPercentageId, SpousePensionPayableOnDeath, ServiceBenefitSpouseEntitled,
		BenefitsPayableOnDeath, DeathBenefit, IsInTrust, IsNRADeffered,
		ConcurrencyId, PensionInfoId, AccrualRate, NICSaving, PercentageReinvestedToPension, NICSavingemployee,
		SECommencementDate, IsContributionsPaid, StampAction, StampDateTime, StampUser,GMPAmount,ProspectivePensionAtRetirement,ProspectiveLumpSumAtRetirement,
		PostSacrificeSalary, SelectedRetirementAge, EarlyRetirementFactorNotes, IndexationNotes, DependantBenefits, EnhancedTaxFreeCash,
		GuaranteedAnnuityRate, ApplicablePenalties, EfiLoyaltyTerminalBonus, GuaranteedGrowthRate, OptionsAvailableAtRetirement,OtherBenefitsAndMaterialFeatures,
		[ProspectivePensionAtRetirementLumpSumTaken], [LifetimeAllowanceUsed],PlanMigrationRef,IndigoClientId, YearsPurchaseAvailability, YearsPurchaseAvailabilityDetails,
		AffinityContributionAvailability, AffinityContributionAvailabilityDetails, CashEquivalentTransferValue, TransferExpiryDate, EmploymentDetailId, CrystallisationStatus, PensionSharingPercentage, PensionAttachmentOrder,
		TaxedPensionAmount,UntaxedPensionAmount,CentrelinkDeductibleAmount,TaxFreePercentageOfIncome,HistoricalCrystallisedPercentage,CurrentCrystallisedPercentage,
		CrystallisedPercentage,UncrystallisedPercentage)
Select PolicyBusinessId, SRA, PensionableSalary, RefReturnDeathTypeId,
		ReturnOnDeathRate, ProtectedRightsOnly, QualifiesDSSIncentive, RefLifeCoverId,
		RebatePaid, ContributionUpdated, IsCurrent, RefSchemeSetUpId,
		HasWidowsPension, HasProtectionAgainstInflation, ProvidesTaxFreeLumpSum, ContractedOutOfS2P,
		ExpectedYearsOfService, NumberOfYearsCompleted, IsIndexed, RefSchemeBasisId,
		FinalSalary, RefContributionPercentageId, SpousePensionPayableOnDeath, ServiceBenefitSpouseEntitled,
		BenefitsPayableOnDeath, DeathBenefit, IsInTrust, IsNRADeffered,
		ConcurrencyId, PensionInfoId, AccrualRate, NICSaving, PercentageReinvestedToPension, NICSavingemployee,
		SECommencementDate, IsContributionsPaid, @StampAction, GetDate(), @StampUser,GMPAmount,ProspectivePensionAtRetirement,ProspectiveLumpSumAtRetirement,
		PostSacrificeSalary, SelectedRetirementAge, EarlyRetirementFactorNotes, IndexationNotes, DependantBenefits, EnhancedTaxFreeCash,
		GuaranteedAnnuityRate, ApplicablePenalties, EfiLoyaltyTerminalBonus, GuaranteedGrowthRate, OptionsAvailableAtRetirement,OtherBenefitsAndMaterialFeatures,
		[ProspectivePensionAtRetirementLumpSumTaken], [LifetimeAllowanceUsed],PlanMigrationRef,IndigoClientId,YearsPurchaseAvailability, YearsPurchaseAvailabilityDetails,
		AffinityContributionAvailability, AffinityContributionAvailabilityDetails, CashEquivalentTransferValue, TransferExpiryDate, EmploymentDetailId, CrystallisationStatus, PensionSharingPercentage, PensionAttachmentOrder,
		TaxedPensionAmount,UntaxedPensionAmount,CentrelinkDeductibleAmount,TaxFreePercentageOfIncome,HistoricalCrystallisedPercentage,CurrentCrystallisedPercentage,CrystallisedPercentage,
		UncrystallisedPercentage
FROM TPensionInfo
WHERE PensionInfoId = @PensionInfoId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
