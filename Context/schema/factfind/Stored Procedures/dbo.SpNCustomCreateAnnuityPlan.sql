SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateAnnuityPlan]
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
	@TotalPurchaseAmount money= null,
	@PremiumStartDate datetime = null,
	@CapitalElement money = null,
	@AssumedGrowthRatePercentage decimal(5, 2) = null,
	@IncomeAmount money = null,
	@IncomeFrequencyId bigint = null,
	@IncomeEffectiveDate datetime = null,
	@RefAnnuityPaymentTypeId bigint = null,
	@PensionCommencementLumpSum money = null,
	@PCLSPaidById bigint = null,
	@IsSpousesBenefit bit = null,
	@SpousesOrDependentsPercentage decimal(5, 2) = null,
	@IsOverlap bit = null,
	@GuaranteedPeriod int = null,
	@IsProportion bit = null,
	@IsCapitalValueProtected bit = null,
	@CapitalValueProtectedAmount money = null,
	-- Mortgage user only.
	@MortgageRepayPercentage money = null,
	@MortgageRepayAmount money = null,
	@ProductName varchar(200) = null,
	@RetirementAge int= null,
	@Indexed bit= null,
	@Preserved bit= null,
	@GMPAmount money = null,
	@SplitTemplateGroupId int = null,
	@TemplateGroupType varchar(255) = null,
	@DeathBenefits [money] = null,
	@AdditionalNotes varchar(1000) = null,
	@PlanCurrency varchar(3) = null,
	@AgencyStatus varchar(50) null = null,
	-- Valuations
	@Valuation money= null,
	@ValuationDate datetime= null,
	@PensionArrangement varchar(100) = null,
	@CrystallisationStatus varchar (20) = null,
	@HistoricalCrystallisedPercentage decimal (10, 2) = null,
	@CurrentCrystallisedPercentage decimal (10, 2) = null,
	@CrystallisedPercentage decimal (10, 2) = null,
	@UncrystallisedPercentage decimal (10, 2) = null
AS
DECLARE @CRMContactId2 bigint, @PolicyBusinessId bigint, @IndigoClientId bigint
-- Is there a client 2?
SELECT @CRMContactId2 = CRMContactId2 FROM TFactFind WHERE CRMContactId1 = @CRMContactId
-- Get tenant id.
SELECT @IndigoClientId = IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId

--------------------------------------------------------------    
-- Create the basic plan data, this will return a PolicyBusinessId    
--------------------------------------------------------------    
EXEC SpNCustomCreatePlan @CRMContactId, @CRMContactId2, @CurrentUserDateTime, @Timezone, NULL, NULL, @PolicyNumber, @Owner, NULL, 
	NULL, NULL, @IndigoClientId, @ProductName, @StampUser, @PolicyStartDate, @SellingAdviser, @PolicyBusinessId OUTPUT,
	@RefPlanTypeId, @RefProdProviderId, NULL, NULL, NULL, NULL,
	@MortgageRepayPercentage, @MortgageRepayAmount, NULL, @RefAnnuityPaymentTypeId, @CapitalElement, @AssumedGrowthRatePercentage,
	@PlanCurrency=@PlanCurrency, @AgencyStatus = @AgencyStatus

IF ISNULL(@PolicyBusinessId, 0) = 0
	RAISERROR('Error occurred when creating Annuity Plan', 11, 1);

-------------------------------------------------------------------------------
-- Create Purchase Premium
-------------------------------------------------------------------------------           
EXEC SpNCustomCreatePlanPremium @StampUser, @PolicyBusinessId, 10, 
	@TotalPurchaseAmount, @PremiumStartDate, 2, 3, @CurrentUserDateTime
      
-------------------------------------------------------------------------------            
-- Create Income Amount
-------------------------------------------------------------------------------
IF((@IncomeAmount IS NOT NULL) AND (@IncomeAmount > 0))
	EXEC [SpNCustomCreatePlanWithdrawal] @StampUser, @PolicyBusinessId,
		@IncomeFrequencyId, @IncomeAmount, @IncomeEffectiveDate, 1

--------------------------------------------------------------
-- Add Pension Info
--------------------------------------------------------------
EXEC [SpNCustomCreatePlanPensionInfo] @StampUser, @PolicyBusinessId, @RetirementAge, @Preserved, @Indexed, @GMPAmount, null, null, null, null, null, null, null, null, null, @DeathBenefits, null, null, null, null, null, 
	@CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement

--------------------------------------------------------------
-- Add a valuation
--------------------------------------------------------------
EXEC [SpNCustomCreatePlanValuation] @StampUser, @PolicyBusinessId, @Valuation, @CurrentUserDateTime, @ValuationDate

-------------------------------------------------------------------------------
-- Create benefits
-------------------------------------------------------------------------------
IF @RefPlanTypeId NOT IN (1173,1174,1175,1176)
EXEC SpNCustomCreatePlanBenefits @StampUser, @IndigoClientId, @PolicyBusinessId, @CRMContactId, NULL,
	@RefPlanTypeId, NULL, NULL, NULL, NULL, NULL, NULL, @CRMContactId, NULL, NULL, NULL,
	NULL, @PensionCommencementLumpSum, @PCLSPaidById, NULL, NULL,
	NULL, NULL, @IsCapitalValueProtected, @CapitalValueProtectedAmount, NULL,
	@IsSpousesBenefit, @SpousesOrDependentsPercentage, @IsOverlap, @GuaranteedPeriod, @IsProportion
ELSE
	EXEC SpNCustomCreatePlanBenefits @StampUser, @IndigoClientId, @PolicyBusinessId, @CRMContactId, NULL,
	@RefPlanTypeId, NULL, NULL, NULL, NULL, NULL, NULL, null, NULL, NULL, NULL,
	NULL, @PensionCommencementLumpSum, @PCLSPaidById, NULL, NULL,
	NULL, NULL, @IsCapitalValueProtected, @CapitalValueProtectedAmount, NULL,
	@IsSpousesBenefit, @SpousesOrDependentsPercentage, @IsOverlap, @GuaranteedPeriod, @IsProportion
--Add Splits for the plan
IF((@SplitTemplateGroupId IS NOT NULL) AND (@SplitTemplateGroupId > 0) AND (@TemplateGroupType IS NOT NULL))
BEGIN
	EXEC [SpNCreateSplitTemplatesForPlans] @IndigoClientId,@CRMContactId, @PolicyBusinessId, @SellingAdviser,@SplitTemplateGroupId,@TemplateGroupType
END

--------------------------------------------------------------
-- Add notes
--------------------------------------------------------------
EXEC [dbo].[SpNCustomCreateOrUpdatePlanAdditionalNotes] @PolicyBusinessId, @AdditionalNotes, @StampUser

--------------------------------------------------------------
-- Return Id to FF.
--------------------------------------------------------------
SELECT @PolicyBusinessId as AnnuityPlanId
GO
