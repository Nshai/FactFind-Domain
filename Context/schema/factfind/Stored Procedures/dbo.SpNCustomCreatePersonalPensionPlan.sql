SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreatePersonalPensionPlan]
	@StampUser varchar(50),
	@CRMContactId bigint,
	@Owner varchar(10),
	@SellingAdviser bigint,
	@RefPlanTypeId bigint,
	@RefProdProviderId bigint,
	@CurrentUserDateTime datetime,
	@Timezone varchar(100),
	@PolicyNumber varchar(50) = null,
	@PolicyStartDate datetime = null,
	@RetirementAge int= null,
	@SelfContributionAmount money= null,
	@EmployerContributionAmount money= null,
	@RefContributionFrequencyId bigint = null,
	@TransferContribution money = null,
	@LumpSumContribution money = null,
	@Valuation money= null,
	@ValuationDate datetime= null,
	@PensionCommencementLumpSum money = null,
	@PCLSPaidById bigint = null,
	@GADMaximumIncomeLimit money = null,
	@GuaranteedMinimumIncome money = null,
	@GADCalculationDate datetime = null,
	@NextReviewDate datetime = null,
	@IsCapitalValueProtected bit = null,
	@CapitalValueProtectedAmount money = null,
	@Indexed bit= null,
	@Preserved bit= null,
	@InTrust bit= null,
	@LumpSumDeathBenefitAmount money = null,
	@PremiumAmount money= null,
	@PremiumFrequencyId bigint = null,
	@PremiumStartDate datetime = null,
	-- Mortgage user only.
	@MortgageRepayPercentage money = null,
	@MortgageRepayAmount money = null,
	@ProductName varchar(200) = null,
	@IsProtectedPCLS bit = null,
	@GMPAmount money = null,
	@SplitTemplateGroupId int = null,
	@TemplateGroupType varchar(255) = null,
	@EnhancedTaxFreeCash [varchar] (100) = null,
	@GuaranteedAnnuityRate [varchar] (100) = null,
	@ApplicablePenalties [varchar] (100) = null,
	@EfiLoyaltyTerminalBonus [varchar] (100) = null,
	@GuaranteedGrowthRate [varchar] (100) = null,
	@OptionsAvailableAtRetirement [varchar] (1000) = null,
	@OtherBenefitsAndMaterialFeatures [varchar] (1000) = null,
	@AdditionalNotes [varchar] (1000) = null,
	@LifetimeAllowanceUsed [decimal] (5, 2) = null,
	@DeathInServiceSpousalBenefits [money] = null,
	@DeathBenefits [money] = null,
	@IsLifeStylingStrategy BIT = NULL,
	@LifeStylingStrategyDetail [varchar] (4000) = NULL,
	@PlanCurrency varchar(3) = null,
	@AgencyStatus varchar(50) = null,
	@TaxedPensionAmount money = null,
	@UntaxedPensionAmount money = null,
	@CrystallisationStatus varchar (20)=null,
	@HistoricalCrystallisedPercentage [decimal] (10, 2) = null,
	@CurrentCrystallisedPercentage [decimal] (10, 2) = null,
	@CrystallisedPercentage [decimal] (10, 2) = null,
	@UncrystallisedPercentage [decimal] (10, 2) = null,
	@PensionArrangement [varchar] (100) = null
AS
DECLARE @CRMContactId2 bigint, @PolicyBusinessId bigint, @IndigoClientId bigint
-- Is there a client 2?
SELECT @CRMContactId2 = CRMContactId2 FROM TFactFind WHERE CRMContactId1 = @CRMContactId
-- Get tenant id.
SELECT @IndigoClientId = IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId

--------------------------------------------------------------
-- Create the basic plan data, this will return a PolicyBusinessId
--------------------------------------------------------------
-- One or the other of contribution/premium should be passed
IF @PremiumAmount IS NOT NULL AND @SelfContributionAmount IS NULL
	SELECT
		@RefContributionFrequencyId = @PremiumFrequencyId,
		@SelfContributionAmount = @PremiumAmount

EXEC SpNCustomCreatePlan @CRMContactId, @CRMContactId2, @CurrentUserDateTime, @Timezone, NULL, NULL, @PolicyNumber, @Owner, @SelfContributionAmount,
	NULL, NULL, @IndigoClientId, @ProductName, @StampUser, @PolicyStartDate, @SellingAdviser, @PolicyBusinessId OUTPUT,
	@RefPlanTypeId, @RefProdProviderId, @RefContributionFrequencyId, @PremiumStartDate, @LumpSumContribution, @TransferContribution,
	@MortgageRepayAmount = @MortgageRepayAmount, @MortgageRepayPercentage = @MortgageRepayPercentage, @PlanCurrency=@PlanCurrency,
	@AgencyStatus = @AgencyStatus

IF ISNULL(@PolicyBusinessId, 0) = 0
	RAISERROR('Error occurred when creating Personal Pension Plan', 11, 1);

--------------------------------------------------------------
-- add an Employer contribution
--------------------------------------------------------------
EXEC SpNCustomCreatePlanPremium @StampUser, @PolicyBusinessId,
	@RefContributionFrequencyId, @EmployerContributionAmount, @PolicyStartDate, 1, 2, @CurrentUserDateTime

--------------------------------------------------------------
-- Add Pension Info
--------------------------------------------------------------
EXEC [SpNCustomCreatePlanPensionInfo] @StampUser, @PolicyBusinessId, @RetirementAge, @Preserved, @Indexed, @GMPAmount,
	@EnhancedTaxFreeCash, @GuaranteedAnnuityRate, @ApplicablePenalties, @EfiLoyaltyTerminalBonus, @GuaranteedGrowthRate,
	@OptionsAvailableAtRetirement, @OtherBenefitsAndMaterialFeatures, @LifetimeAllowanceUsed, @DeathInServiceSpousalBenefits,
	@DeathBenefits, NULL, @IsLifeStylingStrategy, @LifeStylingStrategyDetail, @TaxedPensionAmount, @UntaxedPensionAmount,
	@CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement

--------------------------------------------------------------
-- Add a valuation
--------------------------------------------------------------
EXEC [SpNCustomCreatePlanValuation] @StampUser, @PolicyBusinessId, @Valuation, @CurrentUserDateTime, @ValuationDate

-------------------------------------------------------------------------------
-- Create benefits
-------------------------------------------------------------------------------
IF @RefPlanTypeId NOT IN (1160, 1172)
	EXEC SpNCustomCreatePlanBenefits @StampUser, @IndigoClientId, @PolicyBusinessId, @CRMContactId, NULL,
	@RefPlanTypeId, NULL, NULL, NULL, NULL, NULL, NULL, @CRMContactId, NULL, NULL, NULL,
	@InTrust, @PensionCommencementLumpSum, @PCLSPaidById, @GADMaximumIncomeLimit, @GuaranteedMinimumIncome,
	@GADCalculationDate, @NextReviewDate, @IsCapitalValueProtected, @CapitalValueProtectedAmount, @LumpSumDeathBenefitAmount,
	NULL, NULL, NULL, NULL, NULL,NULL,NULL,NULL,@IsProtectedPCLS
ELSE
	EXEC SpNCustomCreatePlanBenefits @StampUser, @IndigoClientId, @PolicyBusinessId, @CRMContactId, NULL,
	@RefPlanTypeId, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	@InTrust, @PensionCommencementLumpSum, @PCLSPaidById, @GADMaximumIncomeLimit, @GuaranteedMinimumIncome,
	@GADCalculationDate, @NextReviewDate, @IsCapitalValueProtected, @CapitalValueProtectedAmount, @LumpSumDeathBenefitAmount,
	NULL, NULL, NULL, NULL, NULL,NULL,NULL,NULL,@IsProtectedPCLS

--Add Splits for the plan
IF((@SplitTemplateGroupId IS NOT NULL) AND (@SplitTemplateGroupId > 0) AND (@TemplateGroupType IS NOT NULL))
BEGIN
	EXEC [SpNCreateSplitTemplatesForPlans] @IndigoClientId,@CRMContactId, @PolicyBusinessId, @SellingAdviser,@SplitTemplateGroupId,@TemplateGroupType
END

-- Add notes
EXEC [dbo].[SpNCustomCreateOrUpdatePlanAdditionalNotes] @PolicyBusinessId, @AdditionalNotes, @StampUser

--------------------------------------------------------------
-- Return Id to FF.
--------------------------------------------------------------
SELECT @PolicyBusinessId as PersonalPensionPlanId,
	@SelfContributionAmount AS SelfContributionAmount,
	@RefContributionFrequencyId AS RefContributionFrequencyId
GO

