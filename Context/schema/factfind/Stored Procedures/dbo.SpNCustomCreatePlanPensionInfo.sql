SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreatePlanPensionInfo]
	@StampUser varchar(50),
	@PolicyBusinessId bigint,
	@RetirementAge int = null,
	@Preserved bit = null,	
	@Indexed bit = null,
	@GMPAmount money = null,
	@EnhancedTaxFreeCash [varchar] (100) = null,
	@GuaranteedAnnuityRate [varchar] (100) = null,
	@ApplicablePenalties [varchar] (100) = null,
	@EfiLoyaltyTerminalBonus [varchar] (100) = null,
	@GuaranteedGrowthRate [varchar] (100) = null,
	@OptionsAvailableAtRetirement [varchar] (1000) = null,
	@OtherBenefitsAndMaterialFeatures [varchar] (1000) = null,
	@LifetimeAllowanceUsed [decimal] (5, 2) = null,
	@DeathInServiceSpousalBenefits [money] = null,
	@DeathBenefits [money] = null,
	@EmployerContributionDetail [varchar] (4000) = null,
	@IsLifeStylingStrategy bit = null,
	@LifeStylingStrategyDetail VARCHAR(4000) = null,
	@TaxedPensionAmount [money] = null,
	@UntaxedPensionAmount [money] = null,
	@CrystallisationStatus varchar (20)=null,
	@HistoricalCrystallisedPercentage [decimal] (10, 2) = null,
	@CurrentCrystallisedPercentage [decimal] (10, 2) = null,
	@CrystallisedPercentage [decimal] (10, 2) = null,
	@UncrystallisedPercentage [decimal] (10, 2) = null,
	@PensionArrangement [varchar] (100) = null
AS
DECLARE @Id bigint

INSERT INTO PolicyManagement..TPensionInfo (PolicyBusinessId, SRA,  IsCurrent, IsIndexed, GMPAmount, EnhancedTaxFreeCash, GuaranteedAnnuityRate, ApplicablePenalties, EfiLoyaltyTerminalBonus, GuaranteedGrowthRate, OptionsAvailableAtRetirement, OtherBenefitsAndMaterialFeatures, [LifetimeAllowanceUsed], ServiceBenefitSpouseEntitled, DeathBenefit, EmployerContributionDetail, IsLifeStylingStrategy, LifeStylingStrategyDetail, TaxedPensionAmount, UntaxedPensionAmount, CrystallisationStatus, HistoricalCrystallisedPercentage, CurrentCrystallisedPercentage, CrystallisedPercentage, UncrystallisedPercentage, PensionArrangement)
VALUES (@PolicyBusinessId, @RetirementAge, @Preserved, @Indexed, @GMPAmount, @EnhancedTaxFreeCash, @GuaranteedAnnuityRate, @ApplicablePenalties, @EfiLoyaltyTerminalBonus, @GuaranteedGrowthRate, @OptionsAvailableAtRetirement, @OtherBenefitsAndMaterialFeatures, @LifetimeAllowanceUsed, @DeathInServiceSpousalBenefits, @DeathBenefits, @EmployerContributionDetail,@IsLifeStylingStrategy,	@LifeStylingStrategyDetail, @TaxedPensionAmount, @UntaxedPensionAmount, @CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage, @UncrystallisedPercentage, @PensionArrangement)

SET @Id = SCOPE_IDENTITY()  
EXEC PolicyManagement..SpNAuditPensionInfo @StampUser, @Id, 'C'
GO