SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateSavingsPlans]
	@StampUser varchar(50),
	@CRMContactId bigint,
	@Owner varchar(255),
	@SavingsPlansId bigint,
	@ConcurrencyId bigint,
	@CurrentUserDateTime datetime,
	@ProductName varchar(255) = null,
	@CurrentValue money = null,
	@InterestRate varchar(50) = null,
	@SellingAdviser bigint = null,
	@PlanType varchar(255),
	@SavingsPlanPurpose varchar(255)=NULL,
	@SavingsPlansStartDate datetime=NULL,
	@PolicyNumber varchar(50)=null,
	@MaturityDate datetime = null,
	@MortgageRepayPercentage money = null,
	@MortgageRepayAmount money = null,
	@PlanPurposeId bigint=null,
	@PlanCurrency varchar(3) = null,
	@AgencyStatus varchar(50) = null,
    @LastUpdatedDate datetime = null,
	@PensionArrangement varchar(100) = null,
	@CrystallisationStatus varchar (20) = null,
	@HistoricalCrystallisedPercentage decimal (10, 2) = null,
	@CurrentCrystallisedPercentage decimal (10, 2) = null,
	@CrystallisedPercentage decimal (10, 2) = null,
	@UncrystallisedPercentage decimal (10, 2) = null
AS
DECLARE @PolicyBusinessId bigint = @SavingsPlansId, @IsGuaranteed bit, @PolicyBusinessExtId bigint

IF(@PlanPurposeId IS NOT NULL)
  SET @SavingsPlanPurpose = (SELECT Descriptor
                              FROM PolicyManagement..TPlanPurpose 
                              WHERE PlanPurposeId=@PlanPurposeId)  
                                     
-- Update Policy Business
SELECT @IsGuaranteed = IsGuaranteedToProtectOriginalInvestment
FROM PolicyManagement..TPolicyBusiness 
WHERE PolicyBusinessId = @PolicyBusinessId

EXEC [SpNCustomUpdatePlanPolicyBusiness] @StampUser, @PolicyBusinessId, 
	@PolicyNumber, @SavingsPlansStartDate, @MaturityDate, @ProductName, @IsGuaranteed, @PlanCurrency = @PlanCurrency

-- Update Mortgage repay amounts
EXEC SpNCustomUpdateMortgageRepayAmounts @StampUser, @PolicyBusinessId, @MortgageRepayPercentage, @MortgageRepayAmount

-- Update dnpolicymatching
EXEC PolicyManagement..SpNCustomManageDnPolicyMatching @PolicyBusinessId,@StampUser
	
-- Add a new valuation
EXEC SpNCustomCreatePlanValuation @StampUser, @PolicyBusinessId, @CurrentValue, @CurrentUserDateTime, @LastUpdatedDate

-- Update or add the plan purpose.
EXEC FactFind.dbo.SpNCustomUpdatePlanPurpose @PolicyBusinessId,@SavingsPlanPurpose,@StampUser

--------------------------------------------------------------
-- Update Pension Info
--------------------------------------------------------------
EXEC [SpNCustomUpdatePlanPensionInfo] @StampUser, @PolicyBusinessId, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL, NULL,
	@CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement

--Update Agency Status
SELECT @PolicyBusinessExtId = PBE.PolicyBusinessExtId
FROM PolicyManagement.dbo.TPolicyBusinessExt PBE
WHERE PBE.PolicyBusinessId = @PolicyBusinessId;

EXEC PolicyManagement.dbo.SpNAuditPolicyBusinessExt @StampUser, @PolicyBusinessExtId, 'U';

UPDATE PolicyManagement.dbo.TPolicyBusinessExt
SET AgencyStatus = @AgencyStatus
WHERE PolicyBusinessExtId = @PolicyBusinessExtId;

-- Interest Rate
SELECT @PolicyBusinessExtId = PolicyBusinessExtId
FROM  PolicyManagement..TPolicyBusinessExt
WHERE PolicyBusinessId = @PolicyBusinessId
  
EXEC PolicyManagement..SpNAuditPolicyBusinessExt @StampUser, @PolicyBusinessExtId, 'U'  
  
UPDATE PolicyManagement..TPolicyBusinessExt  
SET InterestRate = @InterestRate
WHERE PolicyBusinessExtId = @PolicyBusinessExtId
GO