SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateMoneyPurchasePensionSchemePlans]
	@StampUser varchar(50),
	@CRMContactId bigint,    
	@MoneyPurchasePensionPlansId bigint,    
	@Owner varchar(10),    
	@PlanType bigint,    
	@CurrentUserDateTime datetime, 
	@PolicyNumber varchar(50) = null,    
	@Employer varchar(255) = null,    
	@DateJoined datetime = null,    
	@NormalSchemeRetirementAge int = null,    
	@SelfContributionAmount money = null,    
	@EmployerContributionAmount money = null,    
	@Frequency varchar(255) = null,    
	@Value money = null,    
	@ValuationDate datetime = null,    
	@Indexed bit = null,    
	@Preserved bit = null,    
	@SellingAdviser bigint = null,    
	@LumpSumCommutation money=NULL,  
	@ConcurrencyId bigint, 
	@MortgageRepayPercentage money = null,
	@MortgageRepayAmount money = null,
	@ProductName varchar(200) = null,
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
	@EmployerContributionDetail [varchar](4000) = NULL,
	@IsLifeStylingStrategy bit = NULL,
	@LifeStylingStrategyDetail VARCHAR(4000) = NULL,
	@PlanCurrency varchar(3) = null,
	@AgencyStatus varchar(50) null = null,
	@CrystallisationStatus varchar (20)=null,
	@HistoricalCrystallisedPercentage [decimal] (10, 2) = null,
	@CurrentCrystallisedPercentage [decimal] (10, 2) = null,
	@CrystallisedPercentage [decimal] (10, 2) = null,
	@UncrystallisedPercentage [decimal] (10, 2) = null,
	@PensionArrangement [varchar] (100) = null
AS
DECLARE @PolicyBusinessId bigint = @MoneyPurchasePensionPlansId, 
	@IsGuaranteed bit, @MaturityDate datetime, @PolicyBusinessExtId bigint

-- Update Policy Business
SELECT  @IsGuaranteed = IsGuaranteedToProtectOriginalInvestment, @MaturityDate = MaturityDate
FROM PolicyManagement..TPolicyBusiness 
WHERE PolicyBusinessId = @PolicyBusinessId

EXEC [SpNCustomUpdatePlanPolicyBusiness] @StampUser, @PolicyBusinessId, 
	@PolicyNumber, @DateJoined, @MaturityDate, @ProductName, @IsGuaranteed, @PlanCurrency = @PlanCurrency

-- Update Mortgage repay amounts
EXEC SpNCustomUpdateMortgageRepayAmounts @StampUser, @PolicyBusinessId, @MortgageRepayPercentage, @MortgageRepayAmount
           
-- Update dnpolicymatching  
EXEC PolicyManagement..SpNCustomManageDnPolicyMatching @PolicyBusinessId, @StampUser  
    
-- Update the TPension record
EXEC [SpNCustomUpdatePlanPensionInfo] @StampUser, @PolicyBusinessId, @NormalSchemeRetirementAge, @Preserved, @Indexed, NULL,
	@EnhancedTaxFreeCash, @GuaranteedAnnuityRate, @ApplicablePenalties, @EfiLoyaltyTerminalBonus, @GuaranteedGrowthRate, @OptionsAvailableAtRetirement, @OtherBenefitsAndMaterialFeatures,
	@LifetimeAllowanceUsed, @DeathInServiceSpousalBenefits, @DeathBenefits, @EmployerContributionDetail,@IsLifeStylingStrategy,	@LifeStylingStrategyDetail,
	null, null, @CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement

-- Add a new valuation    
EXEC SpNCustomCreatePlanValuation @StampUser, @PolicyBusinessId, @Value, @CurrentUserDateTime, @ValuationDate

--Update Agency Status
SELECT @PolicyBusinessExtId = PBE.PolicyBusinessExtId
FROM PolicyManagement.dbo.TPolicyBusinessExt PBE
WHERE PBE.PolicyBusinessId = @PolicyBusinessId;

EXEC PolicyManagement.dbo.SpNAuditPolicyBusinessExt @StampUser, @PolicyBusinessExtId, 'U';

UPDATE PolicyManagement.dbo.TPolicyBusinessExt
SET AgencyStatus = @AgencyStatus
WHERE PolicyBusinessExtId = @PolicyBusinessExtId;

-- ext fields       
DECLARE @ExtId bigint    
SELECT @ExtId = MoneyPurchasePensionPlanFFExtId FROM TMoneyPurchasePensionPlanFFExt WHERE PolicyBusinessId = @PolicyBusinessId
IF @ExtId IS NULL BEGIN    
	INSERT INTO TMoneyPurchasePensionPlanFFExt(PolicyBusinessId, Employer,LumpSumCommutation, ConcurrencyId)    
	VALUES (@PolicyBusinessId, @Employer, @LumpSumCommutation, 1)    

	SET @ExtId = SCOPE_IDENTITY()    
	EXEC SpNAuditMoneyPurchasePensionPlanFFExt @StampUser, @ExtId, 'C'
	
END    
ELSE    
BEGIN    
	EXEC SpNAuditMoneyPurchasePensionPlanFFExt @StampUser, @ExtId, 'U'

	UPDATE TMoneyPurchasePensionPlanFFExt     
	SET Employer = @Employer, LumpSumCommutation = @LumpSumCommutation, ConcurrencyId = ConcurrencyId + 1
	WHERE MoneyPurchasePensionPlanFFExtId = @ExtId
END

-- Add notes
EXEC [dbo].[SpNCustomCreateOrUpdatePlanAdditionalNotes] @PolicyBusinessId, @AdditionalNotes, @StampUser
GO