SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdatePersonalPensionPlan]
	@StampUser varchar(50),  
	@PersonalPensionPlanId bigint,
	@ConcurrencyId int = null,
	@CRMContactId bigint,    
	@Owner varchar(10),    
	@CurrentUserDateTime datetime,
	@SellingAdviser bigint = null, -- never should be used for update
	@RefPlanTypeId bigint,    
	@PolicyNumber varchar(50) = null,    
	@PolicyStartDate datetime = null,
	@RetirementAge int= null,    
	@SelfContributionAmount money= null,    
	@EmployerContributionAmount money= null,    
	@RefContributionFrequencyId bigint = null,    
	@TransferContribution money = null,
	@LumpSumContribution money = null,
	@Valuation money= null,    
	@ValuationDate datetime = null,
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
	@IsLifeStylingStrategy BIT = null,
	@LifeStylingStrategyDetail [varchar] (4000) = null,
	@PlanCurrency varchar(3) = null,
	@AgencyStatus varchar(50) null = null,
	@TaxedPensionAmount [money] = null,
	@UntaxedPensionAmount [money] = null,
	@CrystallisationStatus varchar (20)=null,
	@HistoricalCrystallisedPercentage [decimal] (10, 2) = null,
	@CurrentCrystallisedPercentage [decimal] (10, 2) = null,
	@CrystallisedPercentage [decimal] (10, 2) = null,
	@UncrystallisedPercentage [decimal] (10, 2) = null,
	@PensionArrangement [varchar] (100) = null

AS        
DECLARE @PolicyBusinessId bigint = @PersonalPensionPlanId, @IsGuaranteed bit, @MaturityDate datetime, @TenantId bigint,
	@PolicyBusinessExtId bigint

------------------------------------------------------
-- Update Policy Business
------------------------------------------------------	
SELECT  @IsGuaranteed = IsGuaranteedToProtectOriginalInvestment, @MaturityDate = MaturityDate, @TenantId = IndigoClientId
FROM PolicyManagement..TPolicyBusiness 
WHERE PolicyBusinessId = @PolicyBusinessId

EXEC [SpNCustomUpdatePlanPolicyBusiness] @StampUser, @PolicyBusinessId, 
	@PolicyNumber, @PolicyStartDate, @MaturityDate, @ProductName, @IsGuaranteed, @PlanCurrency = @PlanCurrency

-------------------------------------------------------- 
-- Update Mortgage repay amounts
------------------------------------------------------
EXEC SpNCustomUpdateMortgageRepayAmounts @StampUser, @PolicyBusinessId, @MortgageRepayPercentage, @MortgageRepayAmount
           
-------------------------------------------------------- 
-- Update dnpolicymatching  
-------------------------------------------------------- 
EXEC PolicyManagement..SpNCustomManageDnPolicyMatching @PolicyBusinessId,@StampUser  
    
-------------------------------------------------------- 
-- Update the TPension record
-------------------------------------------------------- 
EXEC [SpNCustomUpdatePlanPensionInfo] @StampUser, @PolicyBusinessId, @RetirementAge, @Preserved, @Indexed, @GMPAmount,
	@EnhancedTaxFreeCash, @GuaranteedAnnuityRate, @ApplicablePenalties, @EfiLoyaltyTerminalBonus, @GuaranteedGrowthRate, 
	@OptionsAvailableAtRetirement, @OtherBenefitsAndMaterialFeatures, @LifetimeAllowanceUsed, @DeathInServiceSpousalBenefits, @DeathBenefits, NULL , @IsLifeStylingStrategy, @LifeStylingStrategyDetail, @TaxedPensionAmount, @UntaxedPensionAmount, @CrystallisationStatus,
	@HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage, @UncrystallisedPercentage, @PensionArrangement

-------------------------------------------------------- 
-- Add a new valuation    
-------------------------------------------------------- 
EXEC SpNCustomCreatePlanValuation @StampUser, @PolicyBusinessId, @Valuation, @CurrentUserDateTime, @ValuationDate

-------------------------------------------------------- 
-- Benefits
-------------------------------------------------------- 
EXEC SpNCustomUpdatePlanBenefits @StampUser, @PolicyBusinessId, @TenantId, @RefPlanTypeId, @CRMContactId, @PensionCommencementLumpSum, @PCLSPaidById,
	@GADMaximumIncomeLimit, @GuaranteedMinimumIncome, @GADCalculationDate, @NextReviewDate,
	@IsCapitalValueProtected, @CapitalValueProtectedAmount, @InTrust, @LumpSumDeathBenefitAmount,
	NULL,NULL,NULL,NULL,NULL,@IsProtectedPCLS

-- Add notes
EXEC [dbo].[SpNCustomCreateOrUpdatePlanAdditionalNotes] @PolicyBusinessId, @AdditionalNotes, @StampUser

--Update Agency Status
SELECT @PolicyBusinessExtId = PBE.PolicyBusinessExtId
FROM PolicyManagement.dbo.TPolicyBusinessExt PBE
WHERE PBE.PolicyBusinessId = @PolicyBusinessId;

EXEC PolicyManagement.dbo.SpNAuditPolicyBusinessExt @StampUser, @PolicyBusinessExtId, 'U';

UPDATE PolicyManagement.dbo.TPolicyBusinessExt
SET AgencyStatus = @AgencyStatus
WHERE PolicyBusinessExtId = @PolicyBusinessExtId;
GO