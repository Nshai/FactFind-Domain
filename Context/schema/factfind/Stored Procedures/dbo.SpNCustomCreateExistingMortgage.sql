SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomCreateExistingMortgage]
	@StampUser varchar(50),  
	@CRMContactId bigint,
	@CurrentUserDateTime datetime,
	@Timezone varchar(100),
	@Owner varchar(255) = null,  
	@SellingAdviser bigint = null,  
	@PolicyNumber varchar(50) = null,  
	@RefProdProviderId bigint, 
	@AddressStoreId bigint = null,  
	@RepaymentMethod bigint = null,  
	@RefMortgageBorrowerTypeId bigint = null,  
	@LoanAmount money = null,  
	@InterestRate decimal(10, 5) = null,
	@InterestOnlyAmount money = null,  
	@RepaymentAmount money = null,  
	@MortgageType varchar(255) = null,  
	@FeatureExpiryDate datetime = null,  
	@MortgageTerm decimal(10, 6) = null,  
	@StartDate varchar(255) = null,  
	@MaturityDate datetime = null,  
	@RemainingTerm decimal(10, 6)  = null,  
	@CurrentBalance money = null,  
	@AccountNumber varchar(255) = null,  
	@RedemptionFg bit = Null,  
	@RedemptionAmount money = null, 
	@RedemptionTerms varchar(1000) = null,  
	@RedemptionEndDate datetime = null, 
	@PortableFg bit = Null,  
	@WillBeDischarged bit = null,  
	@AssetId bigint = null,  
	@IncomeStatus varchar(16) = null,
	@BaseRate varchar(50) = null,
	@LenderFee money = null,
	@IsGuarantorMortgage bit = 0,
	@RatePeriodFromCompletionMonths BIGINT = 0,
	@RepayDebtFg bit = null,
	@MonthlyRepaymentAmount money = null,
	@InterestOnlyRepaymentVehicle varchar(255) = null,
	@PropertyType varchar(50) =null,
	@ProductName varchar(200) = null,
	@RepaymentTerm decimal(10, 6) = null,
	@InterestOnlyTerm decimal(10, 6) = null,
	@RefPlanType2ProdSubTypeId bigint = null,
	@IsFirstTimeBuyer bit = null,
	@SplitTemplateGroupId int = null,  
	@TemplateGroupType varchar(255) = null,
	@ConsentToLetFg bit = null,
	@ConsentToLetExpiryDate datetime = null,
	@PercentageOwnership decimal(5, 2) = null,
	@SharedOwnershipBody  varchar(50) = NULL,
	@RentMonthly money = null,
	@PlanCurrency varchar(3) = null,
	@RefEquityLoanSchemeId int = null,
	@EquitySchemeProvider varchar(100) = NULL,
	@EquityRepaymentStartDate datetime = null,
	@EquityLoanPercentage decimal(5, 2) = null,
	@EquityLoanAmount money = null,
	@AddressId bigint = null,
	@AgencyStatus varchar(50) = null,
	@IsToBeConsolidated bit = default,
    @IsLiabilityToBeRepaid bit = null,
    @LiabilityRepaymentDescription varchar(500) = null,
    @BalanceDate datetime = null,
	@PensionArrangement varchar(100) = null,
	@CrystallisationStatus varchar (20) = null,
	@HistoricalCrystallisedPercentage decimal (10, 2) = null,
	@CurrentCrystallisedPercentage decimal (10, 2) = null,
	@CrystallisedPercentage decimal (10, 2) = null,
	@UncrystallisedPercentage decimal (10, 2) = null
AS  
DECLARE @CRMContactId2 bigint, @IndigoClientId bigint, @PolicyBusinessId bigint, @PlanType varchar(255), @MortgageId bigint,
	@StatusFg bit, @NonStatusFg bit, @SelfCertFg bit
    
SELECT @CRMContactId2 = CRMContactId2 FROM TFactFind WHERE CRMContactId1 = @CRMContactId  
SELECT @IndigoClientId = IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId          
SELECT @PlanType = 'Mortgage'

IF @Owner='Client 2'  
	SELECT @CRMContactId=@CRMContactId2 
-- Create the basic plan data, this will return a PolicyBusinessId      
EXEC SpNCustomCreatePlan @CRMContactId, @CRMContactId2, @CurrentUserDateTime, @Timezone, @PlanType, NULL, @PolicyNumber, @Owner, NULL, NULL, @MaturityDate, @IndigoClientId, @ProductName, @StampUser, @StartDate, @SellingAdviser, @PolicyBusinessId OUTPUT, @RefPlanType2ProdSubTypeId,@RefProdProviderId,@PlanCurrency=@PlanCurrency, @AgencyStatus = @AgencyStatus      
-- Check for error.  
IF ISNULL(@PolicyBusinessId, 0) = 0 OR EXISTS (SELECT 1 FROM PolicyManagement..TMortgage WHERE PolicyBusinessId = @PolicyBusinessId)
	RAISERROR('Error occurred when adding Existing Mortgage Details', 11, 1);

--------------------------------------------------------------
-- Add Pension Info
--------------------------------------------------------------
EXEC [SpNCustomCreatePlanPensionInfo] @StampUser, @PolicyBusinessId, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL, NULL,
	@CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement

-- Get status information from status	
SELECT
	@StatusFg = CASE WHEN @IncomeStatus = 'Full Status' THEN 1 ELSE 0 END,
	@SelfCertFg = CASE WHEN @IncomeStatus = 'Self Certified' THEN 1 ELSE 0 END, 
	@NonStatusFg = CASE WHEN @IncomeStatus = 'Non Status' THEN 1 ELSE 0 END

--Update Current Balance field
exec SpNCustomCreateOutstandingBalance @StampUser, @PolicyBusinessId, @CurrentBalance, @CurrentUserDateTime, NULL, @BalanceDate
	
-- Add the mortgage details	
INSERT INTO PolicyManagement..TMortgage (
	PolicyBusinessId, IndigoClientId, MortgageRefNo, LoanAmount, InterestRate, MortgageType, FeatureExpiryDate, 
	PenaltyFg, PenaltyExpiryDate, PortableFg, RedeemedFg, SoldFg, AssetsId, RefMortgageRepaymentMethodId, RefMortgageBorrowerTypeId, MortgageTerm, RemainingTerm, IncomeEvidencedFg, AddressStoreId,
	InterestOnlyAmount, RepaymentAmount, IsCurrentResidence, IsResdidenceAfterComplete, WillBeDischarged, RedemptionAmount,RedemptionTerms,    
	StatusFg, NonStatusFg, SelfCertFg,BaseRate,LenderFee,IsGuarantorMortgage,RatePeriodFromCompletionMonths, RepayDebtFg, MonthlyRepaymentAmount, InterestOnlyRepaymentVehicle,
	PropertyType,CapitalRepaymentTerm,InterestOnlyTerm,IsFirstTimeBuyer, ConsentToLetFg, ConsentToLetExpiryDate, PercentageOwnership, SharedOwnershipBody, RentMonthly,
	RefEquityLoanSchemeId, EquitySchemeProvider, EquityRepaymentStartDate, EquityLoanPercentage, EquityLoanAmount, AddressId, IsToBeConsolidated, IsLiabilityToBeRepaid, LiabilityRepaymentDescription)
VALUES(
	@PolicyBusinessId, @IndigoClientId, @AccountNumber, @LoanAmount, @InterestRate, @MortgageType, @FeatureExpiryDate, 
	@RedemptionFg, @RedemptionEndDate, @PortableFg, 0, 0, @AssetId, @RepaymentMethod, @RefMortgageBorrowerTypeId, @MortgageTerm, @RemainingTerm, 0, @AddressStoreId,     
	@InterestOnlyAmount, @RepaymentAmount, 0, 0, @WillBeDischarged, @RedemptionAmount,@RedemptionTerms, 
	@StatusFg, @NonStatusFg, @SelfCertFg, @BaseRate,@LenderFee,@IsGuarantorMortgage, @RatePeriodFromCompletionMonths, @RepayDebtFg, @MonthlyRepaymentAmount, @InterestOnlyRepaymentVehicle,
	@PropertyType,@RepaymentTerm,@InterestOnlyTerm,@IsFirstTimeBuyer, @ConsentToLetFg, @ConsentToLetExpiryDate, @PercentageOwnership, @SharedOwnershipBody, @RentMonthly,
	@RefEquityLoanSchemeId, @EquitySchemeProvider, @EquityRepaymentStartDate, @EquityLoanPercentage, @EquityLoanAmount, @AddressId, @IsToBeConsolidated, @IsLiabilityToBeRepaid, @LiabilityRepaymentDescription)    

-- Audit.        
SELECT @MortgageId = SCOPE_IDENTITY()
EXEC PolicyManagement..SpNAuditMortgage @StampUser, @MortgageId, 'C'    

IF((@SplitTemplateGroupId IS NOT NULL) AND (@SplitTemplateGroupId > 0) AND (@TemplateGroupType IS NOT NULL))
BEGIN
	EXEC [SpNCreateSplitTemplatesForPlans] @IndigoClientId,@CRMContactId, @PolicyBusinessId, @SellingAdviser,@SplitTemplateGroupId,@TemplateGroupType
END        
-- FF expects the policy business id to be returned.
SELECT @PolicyBusinessId AS 'ExistingMortgageId'  
RETURN(@PolicyBusinessId)

GO