SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[SpNCustomUpdatePlanPensionInfoForAUPensions]
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
	@EmployerContributionDetail [VARCHAR] (4000) = NULL,
	@IsLifeStylingStrategy bit = NULL,
	@LifeStylingStrategyDetail [VARCHAR] (4000) = NULL
AS
DECLARE @PensionInfoId bigint
SELECT @PensionInfoId = PensionInfoId FROM PolicyManagement..TPensionInfo WHERE PolicyBusinessId = @PolicyBusinessId
IF @PensionInfoId IS NULL
	EXEC SpNCustomCreatePlanPensionInfo @StampUser, @PolicyBusinessId, @RetirementAge, @Preserved, @Indexed, @GMPAmount,
		@EnhancedTaxFreeCash, @GuaranteedAnnuityRate, @ApplicablePenalties, @EfiLoyaltyTerminalBonus, @GuaranteedGrowthRate, @OptionsAvailableAtRetirement, @OtherBenefitsAndMaterialFeatures,
		@LifetimeAllowanceUsed, @DeathInServiceSpousalBenefits, @DeathBenefits, @EmployerContributionDetail, @IsLifeStylingStrategy,@LifeStylingStrategyDetail
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
		LifetimeAllowanceUsed = @LifetimeAllowanceUsed,
		ServiceBenefitSpouseEntitled = @DeathInServiceSpousalBenefits,
		DeathBenefit = @DeathBenefits,
		EmployerContributionDetail = @EmployerContributionDetail,
		IsLifeStylingStrategy = @IsLifeStylingStrategy,
		LifeStylingStrategyDetail = @LifeStylingStrategyDetail,
		ConcurrencyId = ConcurrencyId + 1
	WHERE
		PensionInfoId = @PensionInfoId
END
GO
