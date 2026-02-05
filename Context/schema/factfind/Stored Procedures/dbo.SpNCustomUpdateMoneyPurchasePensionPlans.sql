SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateMoneyPurchasePensionPlans]
	@StampUser varchar(50),
	@CRMContactId bigint,    
	@MoneyPurchasePensionPlansId bigint,    
	@Owner varchar(10),    
	@PlanType varchar(255),    
	@Provider varchar(255),
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
	@MortgageRepayAmount money = null	   
AS        
DECLARE @PolicyBusinessId bigint = @MoneyPurchasePensionPlansId, 
	@ProductName varchar(255), @IsGuaranteed bit, @MaturityDate datetime

-- Update Policy Business
SELECT @ProductName = ProductName, @IsGuaranteed = IsGuaranteedToProtectOriginalInvestment, @MaturityDate = MaturityDate
FROM PolicyManagement..TPolicyBusiness 
WHERE PolicyBusinessId = @PolicyBusinessId

EXEC [SpNCustomUpdatePlanPolicyBusiness] @StampUser, @PolicyBusinessId, 
	@PolicyNumber, @DateJoined, @MaturityDate, @ProductName, @IsGuaranteed

-- Update Mortgage repay amounts
EXEC SpNCustomUpdateMortgageRepayAmounts @StampUser, @PolicyBusinessId, @MortgageRepayPercentage, @MortgageRepayAmount
           
-- Update dnpolicymatching  
EXEC PolicyManagement..SpNCustomManageDnPolicyMatching @PolicyBusinessId, @StampUser  
    
-- Update the TPension record
EXEC [SpNCustomUpdatePlanPensionInfo] @StampUser, @PolicyBusinessId, @NormalSchemeRetirementAge, @Preserved, @Indexed
    
-- Add a new valuation    
EXEC SpNCustomCreatePlanValuation @StampUser, @PolicyBusinessId, @Value, @CurrentUserDateTime, @ValuationDate
    
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
GO
