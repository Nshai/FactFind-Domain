SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdatePlanPensionInfo]
	@StampUser bigint, 
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
	@EmployerContributionDetail [VARCHAR] (4000) = null,
	@IsLifeStylingStrategy bit = null,
	@LifeStylingStrategyDetail [VARCHAR] (4000) = null,
	@TaxedPensionAmount [money] = null,
	@UntaxedPensionAmount [money] = null,
	@CrystallisationStatus varchar (20)=null,
	@HistoricalCrystallisedPercentage [decimal] (10, 2) = null,
	@CurrentCrystallisedPercentage [decimal] (10, 2) = null,
	@CrystallisedPercentage [decimal] (10, 2) = null,
	@UncrystallisedPercentage [decimal] (10, 2) = null,
	@PensionArrangement [varchar] (100) = null
AS
DECLARE @PensionInfoId bigint
SELECT @PensionInfoId = PensionInfoId FROM PolicyManagement..TPensionInfo WHERE PolicyBusinessId = @PolicyBusinessId
IF @PensionInfoId IS NULL
	EXEC SpNCustomCreatePlanPensionInfo @StampUser, @PolicyBusinessId, @RetirementAge, @Preserved, @Indexed, @GMPAmount,
		@EnhancedTaxFreeCash, @GuaranteedAnnuityRate, @ApplicablePenalties, @EfiLoyaltyTerminalBonus, @GuaranteedGrowthRate, @OptionsAvailableAtRetirement, @OtherBenefitsAndMaterialFeatures,
		@LifetimeAllowanceUsed, @DeathInServiceSpousalBenefits, @DeathBenefits, @EmployerContributionDetail, @IsLifeStylingStrategy,@LifeStylingStrategyDetail,
		@TaxedPensionAmount, @UntaxedPensionAmount, @CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage, @UncrystallisedPercentage, @PensionArrangement
ELSE BEGIN 
	EXEC PolicyManagement..SpNAuditPensionInfo @StampUser, @PensionInfoId, 'U'
		  
	UPDATE 
		PolicyManagement..TPensionInfo
	SET 
		SRA = @RetirementAge,
		IsCurrent = @Preserved,
		IsIndexed = @Indexed,
		EnhancedTaxFreeCash = @EnhancedTaxFreeCash,
		GuaranteedAnnuityRate = @GuaranteedAnnuityRate,
		ApplicablePenalties = @ApplicablePenalties,
		EfiLoyaltyTerminalBonus = @EfiLoyaltyTerminalBonus,
		GuaranteedGrowthRate = @GuaranteedGrowthRate,
		OptionsAvailableAtRetirement = @OptionsAvailableAtRetirement,
		OtherBenefitsAndMaterialFeatures = @OtherBenefitsAndMaterialFeatures,
		LifetimeAllowanceUsed = @LifetimeAllowanceUsed,
		ServiceBenefitSpouseEntitled = @DeathInServiceSpousalBenefits,
		DeathBenefit = @DeathBenefits,
		EmployerContributionDetail = @EmployerContributionDetail,
		IsLifeStylingStrategy = @IsLifeStylingStrategy,
		LifeStylingStrategyDetail = @LifeStylingStrategyDetail,
		TaxedPensionAmount = @TaxedPensionAmount,
		UntaxedPensionAmount = @UntaxedPensionAmount,
		ConcurrencyId = ConcurrencyId + 1,
		CrystallisationStatus = @CrystallisationStatus,
		HistoricalCrystallisedPercentage=@HistoricalCrystallisedPercentage,
        CurrentCrystallisedPercentage=@CurrentCrystallisedPercentage,
		CrystallisedPercentage=@CrystallisedPercentage,
		UncrystallisedPercentage=@UncrystallisedPercentage,
		PensionArrangement = @PensionArrangement
	WHERE 
		PensionInfoId = @PensionInfoId
END
GO