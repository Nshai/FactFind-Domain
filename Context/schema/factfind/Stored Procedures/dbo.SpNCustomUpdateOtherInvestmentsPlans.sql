SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateOtherInvestmentsPlans]    
 @CRMContactId bigint,    
 @OtherInvestmentsPlansId bigint,    
 @ConcurrencyId bigint,
 @CurrentUserDateTime datetime,
 @CurrentValue money = null,    
 @ValuationDate datetime = null, 
 @MaturityDate datetime = null,    
 @ContributionThisTaxYearFg bit = null,    
 @MonthlyIncome money = null,    
 @InTrustFg bit = Null,    
 @SellingAdviser bigint = null,    
 @Frequency varchar(255) = null,    
 @RegularContribution money = null,    
 @PlanType varchar(255),    
 @OtherInvPlanPurpose varchar(255)=null,    
 @OtherInvStartDate datetime=null,    
 @Owner varchar(255),    
 @PolicyNumber varchar(50)=null,    
 @StampUser varchar(50) ,   
 @annualCharges money = 0 ,  
 @initialCharges money = 0 ,  
 @ongoingCharges money = 0 ,  
 @wrapperCharges money = 0,  
 @MortgageRepayPercentage money = null,  
 @MortgageRepayAmount money = null,  
 @IsGuaranteedToProtectOriginalInvestment bit = null,  
 @OtherPlanPurposeId bigint=null,  
 @LowMaturityValue money = null,  
 @MediumMaturityValue money = null,  
 @HighMaturityValue money = null,  
 @ProjectionDetails varchar(5000) = null,    
 @ToWhom varchar(250)=null,  
 @ProductName varchar(200) = null,  
 @LumpSumContributionAmount money = null,
 @InterestRate money = null,
 @PlanCurrency varchar(3) = null,
 @AgencyStatus varchar(50) null = null,
 @PensionArrangement varchar(100) = null,
@CrystallisationStatus varchar (20) = null,
@HistoricalCrystallisedPercentage decimal (10, 2) = null,
@CurrentCrystallisedPercentage decimal (10, 2) = null,
@CrystallisedPercentage decimal (10, 2) = null,
@UncrystallisedPercentage decimal (10, 2) = null
AS    
DECLARE @TenantId bigint, @PolicyBusinessId bigint = @OtherInvestmentsPlansId, @PolicyBusinessExtId bigint
  
-- Update policy business  
SELECT @TenantId = IndigoClientId  
FROM PolicyManagement..TPolicyBusiness   
WHERE PolicyBusinessId = @PolicyBusinessId  
  
IF(@OtherPlanPurposeId IS NOT NULL)  
  SET @OtherInvPlanPurpose = (SELECT Descriptor  
                              FROM PolicyManagement..TPlanPurpose   
                              WHERE IndigoClientId=@TenantId AND   
                                     PlanPurposeId=@OtherPlanPurposeId)   
      
EXEC SpNCustomUpdatePlanPolicyBusiness @StampUser, @PolicyBusinessId,   
 @PolicyNumber, @OtherInvStartDate, @MaturityDate, @ProductName, @IsGuaranteedToProtectOriginalInvestment,@LowMaturityValue,  
 @MediumMaturityValue,@HighMaturityValue,@ProjectionDetails, @PlanCurrency=@PlanCurrency 
  
-- Update Mortgage repay amounts  
EXEC SpNCustomUpdateMortgageRepayAmounts @StampUser, @PolicyBusinessId, @MortgageRepayPercentage, @MortgageRepayAmount  
  
-- Update dnpolicymatching    
EXEC PolicyManagement..SpNCustomManageDnPolicyMatching @PolicyBusinessId, @StampUser    
    
-- Add a new valuation    
EXEC SpNCustomCreatePlanValuation @StampUser, @PolicyBusinessId, @CurrentValue, @CurrentUserDateTime, @ValuationDate  
    
-- Ext fields      
DECLARE @OtherInvestmentsPlanFFExtId bigint    
SELECT @OtherInvestmentsPlanFFExtId = OtherInvestmentsPlanFFExtId FROM TOtherInvestmentsPlanFFExt WHERE PolicyBusinessId = @PolicyBusinessId  
IF @OtherInvestmentsPlanFFExtId IS NULL BEGIN    
 INSERT INTO TOtherInvestmentsPlanFFExt(PolicyBusinessId, ContributionThisTaxYearFg, MonthlyIncome, InTrustFg, ConcurrencyId)    
 VALUES (@PolicyBusinessId, @ContributionThisTaxYearFg, @MonthlyIncome, @InTrustFg, 1)    
  
 SET @OtherInvestmentsPlanFFExtId = SCOPE_IDENTITY()    
 EXEC SpNAuditOtherInvestmentsPlanFFExt @StampUser, @OtherInvestmentsPlanFFExtId, 'C'  
END    
ELSE BEGIN    
 EXEC SpNAuditOtherInvestmentsPlanFFExt @StampUser, @OtherInvestmentsPlanFFExtId, 'U'  
  
 UPDATE TOtherInvestmentsPlanFFExt     
 SET ContributionThisTaxYearFg = @ContributionThisTaxYearFg,    
  MonthlyIncome = @MonthlyIncome,    
  InTrustFg = @InTrustFg, ConcurrencyId = ConcurrencyId + 1  
 WHERE OtherInvestmentsPlanFFExtId = @OtherInvestmentsPlanFFExtId  
END    
   
-- Benefits      
exec SpNCustomAddInTrust @StampUser, @TenantId, @PolicyBusinessId, @InTrustFg,@ToWhom  

--------------------------------------------------------------
-- Update Pension Info
--------------------------------------------------------------
EXEC [SpNCustomUpdatePlanPensionInfo] @StampUser, @PolicyBusinessId, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL, NULL,
	@CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement

-- Update or add the plan purpose.    
exec FactFind.dbo.SpNCustomUpdatePlanPurpose @PolicyBusinessId, @OtherInvPlanPurpose,@StampUser,@OtherPlanPurposeId

--Update Agency Status
SELECT @PolicyBusinessExtId = PBE.PolicyBusinessExtId
FROM PolicyManagement.dbo.TPolicyBusinessExt PBE
WHERE PBE.PolicyBusinessId = @PolicyBusinessId;

EXEC PolicyManagement.dbo.SpNAuditPolicyBusinessExt @StampUser, @PolicyBusinessExtId, 'U';

UPDATE PolicyManagement.dbo.TPolicyBusinessExt
SET AgencyStatus = @AgencyStatus
WHERE PolicyBusinessExtId = @PolicyBusinessExtId;

-- Annual charges  
SELECT @PolicyBusinessExtId = PolicyBusinessExtId  
FROM  PolicyManagement..TPolicyBusinessExt  
WHERE PolicyBusinessId = @PolicyBusinessId  
  
EXEC PolicyManagement..SpNAuditPolicyBusinessExt @StampUser, @PolicyBusinessExtId, 'U'  
  
UPDATE PolicyManagement..TPolicyBusinessExt  
SET  AnnualCharges = @annualCharges,  
  WrapperCharge = @wrapperCharges,  
  InitialAdviceCharge = @initialCharges,
  OngoingAdviceCharge = @ongoingCharges,
  InterestRate = @InterestRate,
  ConcurrencyId = ConcurrencyId +1  
WHERE PolicyBusinessId = @PolicyBusinessId  

GO