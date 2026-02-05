SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateAnnuityPlan]
	@StampUser varchar(50),  
	@AnnuityPlanId bigint,
	@ConcurrencyId int = null,
	@CRMContactId bigint,    
	@Owner varchar(10),
	@CurrentUserDateTime datetime = null,    
	@SellingAdviser bigint = null,-- never should be used for update    
	@RefPlanTypeId bigint,
	@PolicyNumber varchar(50) = null,
	@PolicyStartDate datetime = null,
	@TotalPurchaseAmount money= null,
	@PremiumStartDate datetime = null,
	@CapitalElement money = null,
	@AssumedGrowthRatePercentage decimal(5, 2) = null,
	@IncomeAmount money= null,
	@IncomeFrequencyId bigint = null,
	@IncomeEffectiveDate datetime = null,
	@RefAnnuityPaymentTypeId bigint = null,
	@PensionCommencementLumpSum money = null,
	@PCLSPaidById bigint = null,
	@IsSpousesBenefit bit = null,
	@SpousesOrDependentsPercentage decimal(5,2) = null,
	@IsOverlap bit = null,
	@GuaranteedPeriod int = null,
	@IsProportion bit = null,
	@IsCapitalValueProtected bit = null,
	@CapitalValueProtectedAmount money = null,
	-- Mortgage user only.
	@MortgageRepayPercentage money = null,
	@MortgageRepayAmount money = null,
	@ProductName varchar(200) = null,
	@DeathBenefits [money] = null,
	@AdditionalNotes varchar(1000)= null,
	@PlanCurrency varchar(3) = null,
	@AgencyStatus varchar(50) = null,
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
DECLARE @PolicyBusinessId bigint = @AnnuityPlanId, @IsGuaranteed bit, @MaturityDate datetime, @TenantId bigint,
	@PolicyBusinessExtId bigint

------------------------------------------------------
-- Update Policy Business
------------------------------------------------------	
SELECT @IsGuaranteed = IsGuaranteedToProtectOriginalInvestment, @MaturityDate = MaturityDate, @TenantId = IndigoClientId
FROM PolicyManagement..TPolicyBusiness 
WHERE PolicyBusinessId = @PolicyBusinessId

EXEC [SpNCustomUpdatePlanPolicyBusiness] @StampUser, @PolicyBusinessId,
	@PolicyNumber, @PolicyStartDate, @MaturityDate, @ProductName, @IsGuaranteed, @PlanCurrency = @PlanCurrency

------------------------------------------------------
-- Update Policy Detail
------------------------------------------------------	
EXEC [SpNCustomUpdatePlanPolicyDetail] @StampUser, @PolicyBusinessId, @RefAnnuityPaymentTypeId,	@CapitalElement, @AssumedGrowthRatePercentage

-------------------------------------------------------- 
-- Update Mortgage repay amounts
------------------------------------------------------
EXEC SpNCustomUpdateMortgageRepayAmounts @StampUser, @PolicyBusinessId, @MortgageRepayPercentage, @MortgageRepayAmount

-------------------------------------------------------- 
-- Update dnpolicymatching  
-------------------------------------------------------- 
EXEC PolicyManagement..SpNCustomManageDnPolicyMatching @PolicyBusinessId, @StampUser

--Update Agency Status
SELECT @PolicyBusinessExtId = PBE.PolicyBusinessExtId
FROM PolicyManagement.dbo.TPolicyBusinessExt PBE
WHERE PBE.PolicyBusinessId = @PolicyBusinessId;

EXEC PolicyManagement.dbo.SpNAuditPolicyBusinessExt @StampUser, @PolicyBusinessExtId, 'U';

UPDATE PolicyManagement.dbo.TPolicyBusinessExt
SET AgencyStatus = @AgencyStatus
WHERE PolicyBusinessExtId = @PolicyBusinessExtId;

--------------------------------------------------------------    
-- Update Pension Info
--------------------------------------------------------------    
IF @RefPlanTypeId NOT IN (1173,1174,1175,1176)
	EXEC [SpNCustomUpdatePlanPensionInfo] @StampUser, @PolicyBusinessId, null, null, null, null, null, null, null, null, null, null, null, null, null, @DeathBenefits, null, null, null, null, null, 
	@CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement
ELSE
	EXEC [SpNCustomUpdatePlanPensionInfoForAUPensions] @StampUser, @PolicyBusinessId, null, null, null, null, null, null, null, null, null, null, null, null, null, @DeathBenefits

-- Add a new valuation    
-------------------------------------------------------- 
EXEC SpNCustomCreatePlanValuation @StampUser, @PolicyBusinessId, @Valuation, @CurrentUserDateTime, @ValuationDate

-------------------------------------------------------- 
-- Benefits
-------------------------------------------------------- 
EXEC SpNCustomUpdatePlanBenefits @StampUser, @PolicyBusinessId, @TenantId, @RefPlanTypeId, @CRMContactId, 
	@PensionCommencementLumpSum, @PCLSPaidById, NULL, NULL, NULL, NULL, @IsCapitalValueProtected, @CapitalValueProtectedAmount, 
	NULL, NULL, @IsSpousesBenefit, @SpousesOrDependentsPercentage, @IsOverlap, @GuaranteedPeriod, @IsProportion

--------------------------------------------------------------    
-- Add notes
--------------------------------------------------------------    
EXEC [dbo].[SpNCustomCreateOrUpdatePlanAdditionalNotes] @PolicyBusinessId, @AdditionalNotes, @StampUser
GO