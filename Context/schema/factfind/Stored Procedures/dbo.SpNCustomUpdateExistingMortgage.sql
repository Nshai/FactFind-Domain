SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateExistingMortgage]  
	@StampUser varchar(255),
	@ExistingMortgageId bigint, --PolicyBusinessId    
	@ConcurrencyId int,
	@CRMContactId bigint,
	@CurrentUserDateTime datetime,   
	@Owner varchar(255) = null,  
	@SellingAdviser bigint = null,  
	@PolicyNumber varchar(50) = null,
	@AddressStoreId bigint = null,  
	@RepaymentMethod bigint = null,  
	@RefMortgageBorrowerTypeId bigint = null,  
	@LoanAmount money = null,  
	@InterestRate decimal(10, 5) = null,
	@InterestOnlyAmount money = null,  
	@RepaymentAmount money = null,  
	@MortgageType varchar(255) = null,  
	@FeatureExpiryDate datetime = null,  
	@MortgageTerm decimal(10,6) = null,  
	@StartDate varchar(255) = null,  
	@MaturityDate datetime = null,  
	@RemainingTerm decimal(10,6)  = null,  
	@CurrentBalance money = null,  
	@AccountNumber varchar(255) = null,  
	@RedemptionFg bit = null,  
	@RedemptionAmount money = null, 
	@RedemptionTerms varchar(1000) = null,   
	@RedemptionEndDate datetime = null, 
	@PortableFg bit = null,  
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
DECLARE @TenantId bigint, @MortgageId bigint, @PolicyBusinessId bigint = @ExistingMortgageId,
	@StatusFg bit, @NonStatusFg bit, @SelfCertFg bit, @IsGuaranteed bit, @PolicyBusinessExtId bigint
  
SELECT @TenantId = IndigoClientId, @IsGuaranteed = IsGuaranteedToProtectOriginalInvestment
FROM PolicyManagement..TPolicyBusiness 
WHERE PolicyBusinessId = @PolicyBusinessId

-- Make sure TMortgage record exists
SELECT @MortgageId = MortgageId FROM PolicyManagement..TMortgage WHERE PolicyBusinessId = @PolicyBusinessId 
IF @MortgageId IS NULL BEGIN
	-- Create TMortgage
	INSERT INTO PolicyManagement..TMortgage (PolicyBusinessId, IndigoClientId, PenaltyFg)
	VALUES (@PolicyBusinessId, @TenantId, 0)

	SET @MortgageId = SCOPE_IDENTITY()	
	EXEC PolicyManagement..SpNAuditMortgage @StampUser, @MortgageId, 'C'
END
   
-- Update Policy Business details
EXEC SpNCustomUpdatePlanPolicyBusiness @StampUser, @PolicyBusinessId, 
	@PolicyNumber, @StartDate, @MaturityDate, @ProductName, @IsGuaranteed, @PlanCurrency = @PlanCurrency

-- Update dnpolicymatching  
EXEC PolicyManagement..SpNCustomManageDnPolicyMatching @PolicyBusinessId, @StampUser 

-- Get the RefPlanType2ProdSubTypeId for the chosen plan /sub type                  
IF @RefPlanType2ProdSubTypeId IS NULL  
BEGIN        
	SELECT @RefPlanType2ProdSubTypeId = t.RefPlanType2ProdSubTypeId                  
	FROM PolicyManagement..TRefPlanType2ProdSubType t                  
	JOIN PolicyManagement..TRefPlanType rpt ON rpt.RefPlanTypeId = t.RefPlanTypeId                  
	LEFT JOIN PolicyManagement..TProdSubType pst ON pst.ProdSubTypeId = t.ProdSubTypeId                  
	WHERE rpt.PlanTypeName + isnull(' (' + pst.ProdSubTypeName + ')','') = 'Mortgage' 
END

-- Update Plan Description table  
EXEC factfind..SpNCustomUpdatePlanDescription @StampUser, @PolicyBusinessId, @RefPlanType2ProdSubTypeId

-- Update the Mortgage  
EXEC PolicyManagement..SpNAuditMortgage @StampUser, @MortgageId, 'U'  

-- Get status information from status	
SELECT
	@StatusFg = CASE WHEN @IncomeStatus = 'Full Status' THEN 1 ELSE 0 END,
	@SelfCertFg = CASE WHEN @IncomeStatus = 'Self Certified' THEN 1 ELSE 0 END, 
	@NonStatusFg = CASE WHEN @IncomeStatus = 'Non Status' THEN 1 ELSE 0 END

--Update Current Balance field
exec SpNCustomCreateOutstandingBalance @StampUser, @PolicyBusinessId, @CurrentBalance, @CurrentUserDateTime, NULL, @BalanceDate

--Update Agency Status
SELECT @PolicyBusinessExtId = PBE.PolicyBusinessExtId
FROM PolicyManagement.dbo.TPolicyBusinessExt PBE
WHERE PBE.PolicyBusinessId = @PolicyBusinessId;

--------------------------------------------------------------
-- Update Pension Info
--------------------------------------------------------------
EXEC [SpNCustomUpdatePlanPensionInfo] @StampUser, @PolicyBusinessId, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL, NULL,
	@CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement


EXEC PolicyManagement.dbo.SpNAuditPolicyBusinessExt @StampUser, @PolicyBusinessExtId, 'U';

UPDATE PolicyManagement.dbo.TPolicyBusinessExt
SET AgencyStatus = @AgencyStatus
WHERE PolicyBusinessExtId = @PolicyBusinessExtId;
	
UPDATE PolicyManagement..TMortgage  
SET MortgageRefNo = @AccountNumber, MortgageType = @MortgageType,  
	PenaltyFg = @RedemptionFg, PenaltyExpiryDate = @RedemptionEndDate, PortableFg = @PortableFg, AssetsId = @AssetId,  
	RefMortgageRepaymentMethodId = @RepaymentMethod, RefMortgageBorrowerTypeId = @RefMortgageBorrowerTypeId, 
	MortgageTerm = @MortgageTerm, RemainingTerm = @RemainingTerm,  
	AddressStoreId = @AddressStoreId, InterestOnlyAmount = @InterestOnlyAmount, RepaymentAmount=@RepaymentAmount,  
	WillBeDischarged = @WillBeDischarged,  
	RedemptionAmount = @RedemptionAmount, RedemptionTerms=@RedemptionTerms, LoanAmount = @LoanAmount, InterestRate = @InterestRate, FeatureExpiryDate = @FeatureExpiryDate,
	StatusFg = @StatusFg, SelfCertFg = @SelfCertFg, NonStatusFg = @NonStatusFg, 
	BaseRate = @BaseRate, LenderFee=@LenderFee, 
	IsGuarantorMortgage = @IsGuarantorMortgage, RatePeriodFromCompletionMonths = @RatePeriodFromCompletionMonths, RepayDebtFg = @RepayDebtFg, MonthlyRepaymentAmount = @MonthlyRepaymentAmount,
	InterestOnlyRepaymentVehicle = @InterestOnlyRepaymentVehicle,PropertyType=@PropertyType,
	ConcurrencyId=ConcurrencyId + 1,CapitalRepaymentTerm = @RepaymentTerm, InterestOnlyTerm = @InterestOnlyTerm  ,
	IsFirstTimeBuyer = @IsFirstTimeBuyer,
	ConsentToLetFg = @ConsentToLetFg,
	ConsentToLetExpiryDate = CASE
			 WHEN @ConsentToLetFg = 0 THEN NULL
			 ELSE @ConsentToLetExpiryDate
		 END,
	PercentageOwnership = @PercentageOwnership,
	SharedOwnershipBody = @SharedOwnershipBody,
	RentMonthly = @RentMonthly,
	RefEquityLoanSchemeId =@RefEquityLoanSchemeId,
	EquitySchemeProvider = CASE
			 WHEN @RefEquityLoanSchemeId IN (7, 8) THEN @EquitySchemeProvider
			 ELSE NULL
		END,
	EquityRepaymentStartDate = @EquityRepaymentStartDate,
	EquityLoanPercentage = @EquityLoanPercentage,
	EquityLoanAmount = @EquityLoanAmount,
	AddressId = @AddressId,
	IsToBeConsolidated = @IsToBeConsolidated,
	IsLiabilityToBeRepaid = @IsLiabilityToBeRepaid,
	LiabilityRepaymentDescription = @LiabilityRepaymentDescription
WHERE 
	MortgageId = @MortgageId
GO