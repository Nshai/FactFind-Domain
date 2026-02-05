SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateOtherInvestmentsPlans]   
 @CRMContactId bigint,  
 @PlanType bigint,
 @CurrentUserDateTime datetime,
 @Timezone varchar(100),
 @OtherInvPlanPurpose varchar(255)=null,  
 @OtherInvStartDate datetime=null,  
 @PolicyNumber varchar(50)=null,  
 @RefProdProviderId bigint, 
 @MaturityDate datetime = NULL,  
 @CurrentValue money = NULL,  
 @ValuationDate datetime = NULL,  
 @ContributionThisTaxYearFg bit = NULL,  
 @RegularContribution money = NULL,  
 @Frequency varchar(50) = NULL,  
 @MonthlyIncome money = NULL,  
 @InTrustFg bit = Null,  
 @Owner varchar(255),  
 @SellingAdviser bigint,  
 @StampUser varchar(255),    
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
 @SplitTemplateGroupId int = null,  
 @TemplateGroupType varchar(255) = null,
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
DECLARE @CRMContactId2 bigint, @PolicyBusinessId bigint, @PlanPurposeId bigint
  
-- is there a client 2?  
SET @CRMContactId2 = (Select CRMContactId2 FROM TFactFind WHERE CRMContactId1 = @CRMContactId)  
  
-- Get the indigoClientId, use the CRMContactId to get it  
DECLARE @IndigoClientId bigint  
  
SET @IndigoClientId = (  
 SELECT IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId)  
   
IF(@OtherPlanPurposeId IS NOT NULL)  
  SET @OtherInvPlanPurpose = (SELECT Descriptor  
                              FROM PolicyManagement..TPlanPurpose   
                              WHERE IndigoClientId=@IndigoClientId AND   
                                     PlanPurposeId=@OtherPlanPurposeId)    
  
-- create the basic plan data, this will return a PolicyBusinessId  
exec SpNCustomCreatePlan @CRMContactId, @CRMContactId2, @CurrentUserDateTime, @Timezone, null, @OtherInvPlanPurpose, @PolicyNumber, @Owner,   
 @RegularContribution, @Frequency, @MaturityDate, @IndigoClientId, @ProductName , @StampUser, @OtherInvStartDate, @SellingAdviser, @PolicyBusinessId OUTPUT,  
 @RefProdProviderId = @RefProdProviderId, @LumpSumContributionAmount=@LumpSumContributionAmount,@MortgageRepayAmount = @MortgageRepayAmount, 
 @MortgageRepayPercentage = @MortgageRepayPercentage, @IsGuaranteedToProtectOriginalInvestment = @IsGuaranteedToProtectOriginalInvestment,  
 @RefPlanType2ProdSubTypeId = @PlanType,@LowMaturityValue = @LowMaturityValue,@MediumMaturityValue = @MediumMaturityValue,  
 @HighMaturityValue = @HighMaturityValue, @ProjectionDetails = @ProjectionDetails, @PlanPurposeId = @OtherPlanPurposeId,
 @InterestRate = @InterestRate, @PlanCurrency = @PlanCurrency, @AgencyStatus = @AgencyStatus
  
-- Add a valuation  
EXEC SpNCustomCreatePlanValuation @StampUser, @PolicyBusinessId, @CurrentValue, @CurrentUserDateTime, @Date= @ValuationDate  

-- Exec SplitTemplate for Plan
IF((@SplitTemplateGroupId IS NOT NULL) AND (@SplitTemplateGroupId > 0) AND (@TemplateGroupType IS NOT NULL))
BEGIN
	EXEC SpNCreateSplitTemplatesForPlans @IndigoClientId,@CRMContactId, @PolicyBusinessId, @SellingAdviser,@SplitTemplateGroupId,@TemplateGroupType
END

--------------------------------------------------------------
-- Add Pension Info
--------------------------------------------------------------
EXEC [SpNCustomCreatePlanPensionInfo] @StampUser, @PolicyBusinessId, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL, NULL,
	@CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement

-- ext fields  
DECLARE @OtherInvestmentsPlanFFExtId bigint  
  
INSERT INTO TOtherInvestmentsPlanFFExt(PolicyBusinessId, ContributionThisTaxYearFg, MonthlyIncome, ConcurrencyId)  
VALUES (@PolicyBusinessId, @ContributionThisTaxYearFg,@MonthlyIncome, 1)  
 
SET @OtherInvestmentsPlanFFExtId = SCOPE_IDENTITY()  
  
INSERT INTO TOtherInvestmentsPlanFFExtAudit(PolicyBusinessId, ContributionThisTaxYearFg, MonthlyIncome, ConcurrencyId, OtherInvestmentsPlanFFExtId, StampAction, StampDateTime, StampUser)  
VALUES (@PolicyBusinessId, @ContributionThisTaxYearFg,@MonthlyIncome, 1, @OtherInvestmentsPlanFFExtId, 'C', getdate(), @StampUser)  
  
IF @InTrustFg is not null  
 exec SpNCustomAddInTrust @StampUser, @IndigoClientId, @PolicyBusinessId, @InTrustFg,@ToWhom  
  
SELECT @PolicyBusinessId as OtherInvestmentsPlansId  
  
GO