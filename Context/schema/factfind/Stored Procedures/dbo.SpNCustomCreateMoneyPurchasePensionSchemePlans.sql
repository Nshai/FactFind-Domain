SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateMoneyPurchasePensionSchemePlans]
	@CRMContactId bigint,    
	@Owner varchar(10),    
	@PlanType bigint,
	@CurrentUserDateTime datetime,
	@Timezone varchar(100),
	@PolicyNumber varchar(50) = null,    
	@RefProdProviderId bigint,
	@Employer varchar(255) = null,    
	@DateJoined datetime = null,    
	@NormalSchemeRetirementAge int = null,    
	@SelfContributionAmount money = null,    
	@EmployerContributionAmount money = null,    
	@Frequency varchar(255),    
	@Value money = null,    
	@ValuationDate datetime = null,    
	@Indexed bit = null,    
	@Preserved bit = null,    
	@SellingAdviser bigint,    
	@LumpSumCommutation money = null,  
	@StampUser varchar(50),  
	@MortgageRepayPercentage money  = null,
	@MortgageRepayAmount money  = null,
	@ProductName varchar(200) = null,
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
	@EmployerContributionDetail VARCHAR(4000) = NULL,
	@IsLifeStylingStrategy bit = NULL,
	@LifeStylingStrategyDetail VARCHAR(4000) = NULL,
	@PlanCurrency varchar(3) = null,
	@AgencyStatus varchar(50) null = null,
	@PensionArrangement varchar(100) = null,
	@CrystallisationStatus varchar (20) = null,
	@HistoricalCrystallisedPercentage decimal (10, 2) = null,
	@CurrentCrystallisedPercentage decimal (10, 2) = null,
	@CrystallisedPercentage decimal (10, 2) = null,
	@UncrystallisedPercentage decimal (10, 2) = null
AS
DECLARE @CRMContactId2 bigint, @PolicyBusinessId bigint    
DECLARE @ContributionStartDate datetime = ISNULL(@DateJoined, @CurrentUserDateTime)            
    
-- is there a client 2?    
SET @CRMContactId2 = (Select CRMContactId2 FROM TFactFind WHERE CRMContactId1 = @CRMContactId)    
    
-- Get the indigoClientId, use the CRMContactId to get it    
DECLARE @IndigoClientId bigint         
SET @IndigoClientId = (SELECT IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId)    
    
--------------------------------------------------------------    
-- create the basic plan data, this will return a PolicyBusinessId    
--------------------------------------------------------------    
exec SpNCustomCreatePlan @CRMContactId, @CRMContactId2, @CurrentUserDateTime, @Timezone, NULL, NULL, @PolicyNumber, @Owner, @SelfContributionAmount, 
	@Frequency, null, @IndigoClientId, @ProductName, @StampUser, @DateJoined, @SellingAdviser, @PolicyBusinessId OUTPUT, @RefProdProviderId = @RefProdProviderId,
	@LumpSumContributionAmount=@LumpSumCommutation,@MortgageRepayAmount = @MortgageRepayAmount, @MortgageRepayPercentage = @MortgageRepayPercentage,@RefPlanType2ProdSubTypeId = @PlanType,
	@PlanCurrency = @PlanCurrency, @AgencyStatus = @AgencyStatus

IF ISNULL(@PolicyBusinessId,0) = 0 
	RAISERROR('Error occurred when creating Personal Pension Plan', 11, 1);

--------------------------------------------------------------    
-- add an Employer contribution    
--------------------------------------------------------------    
IF @EmployerContributionAmount IS NOT NULL AND @Frequency IS NOT NULL BEGIN    
	DECLARE @RefFrequencyId bigint    
	SET @RefFrequencyId = (    
		SELECT RefFrequencyId     
		FROM PolicyManagement..TRefFrequency rf    
		WHERE FrequencyName = @Frequency    
		AND RetireFg = 0    
	)    

	EXEC SpNCustomCreatePlanPremium @StampUser, @PolicyBusinessId,  
		@RefFrequencyId, @EmployerContributionAmount, @ContributionStartDate, 1, 2, @CurrentUserDateTime
END    	

--------------------------------------------------------------    
-- Add Pension Info
--------------------------------------------------------------    
EXEC [SpNCustomCreatePlanPensionInfo] @StampUser, @PolicyBusinessId, @NormalSchemeRetirementAge, @Preserved, @Indexed, @GMPAmount,
	@EnhancedTaxFreeCash, @GuaranteedAnnuityRate, @ApplicablePenalties, @EfiLoyaltyTerminalBonus, @GuaranteedGrowthRate, @OptionsAvailableAtRetirement, @OtherBenefitsAndMaterialFeatures,
	@LifetimeAllowanceUsed, @DeathInServiceSpousalBenefits, @DeathBenefits, @EmployerContributionDetail, @IsLifeStylingStrategy,@LifeStylingStrategyDetail,
	null, null, @CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement

--------------------------------------------------------------    
-- Add a valuation        
--------------------------------------------------------------    
EXEC SpNCustomCreatePlanValuation @StampUser, @PolicyBusinessId, @Value, @CurrentUserDateTime, @ValuationDate

--------------------------------------------------------------    
-- Ext fields    
--------------------------------------------------------------    
DECLARE @MoneyPurchasePensionPlanFFExtId bigint    

INSERT INTO TMoneyPurchasePensionPlanFFExt(PolicyBusinessId, Employer, LumpSumCommutation,ConcurrencyId)    
VALUES (@PolicyBusinessId, @Employer, @LumpSumCommutation, 1)    

SET @MoneyPurchasePensionPlanFFExtId =  SCOPE_IDENTITY()      
EXEC SpNAuditMoneyPurchasePensionPlanFFExt @StampUser, @MoneyPurchasePensionPlanFFExtId, 'C'  

--Add Splits for the plan
IF((@SplitTemplateGroupId IS NOT NULL) AND (@SplitTemplateGroupId > 0) AND (@TemplateGroupType IS NOT NULL))
BEGIN
	EXEC [SpNCreateSplitTemplatesForPlans] @IndigoClientId,@CRMContactId, @PolicyBusinessId, @SellingAdviser,@SplitTemplateGroupId,@TemplateGroupType
END

-- Add notes
EXEC [dbo].[SpNCustomCreateOrUpdatePlanAdditionalNotes] @PolicyBusinessId, @AdditionalNotes, @StampUser

-- return    
SELECT @PolicyBusinessId as MoneyPurchasePensionPlansId 
GO