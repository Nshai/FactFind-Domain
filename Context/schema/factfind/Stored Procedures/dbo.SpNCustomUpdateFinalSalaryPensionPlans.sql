SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateFinalSalaryPensionPlans]   
	@StampUser varchar(255),    
	@CRMContactId bigint,  
	@Owner varchar(50),  
	@FinalSalaryPensionPlansId bigint,  
	@Employer varchar(255) = null,  
	@NormalSchemeRetirementAge int = null,  
	@AccrualRate int = null,  
	@DateJoined datetime = null,  
	@ExpectedYearsOfService int = null,  
	@PensionableSalary money = null,  
	@Indexed bit=null,  
	@Preserved bit=null,  
	@SellingAdviser bigint = null,  -- not used for edit
	@PolicyNumber varchar(50)=null,  
	@ConcurrencyId bigint,  
	@MortgageRepayPercentage money = null,
	@MortgageRepayAmount money = null,
	@ProductName varchar(200)=null,
	@ProspectivePensionAtRetirement money =null,
	@ProspectiveLumpSumAtRetirement	money=null,
	@EarlyRetirementFactorNotes varchar(1000)= null,
	@DependantBenefits [varchar] (100)= null,
	@IndexationNotes varchar(1000)= null,
	@AdditionalNotes varchar(1000)= null,
	@ProspectivePensionAtRetirementLumpSumTaken money = null,
	@DeathInServiceSpousalBenefits [money] = null,
	@YearsPurchaseAvailability [bit] = null,
	@YearsPurchaseAvailabilityDetails [varchar] (4000) = null,
	@AffinityContributionAvailability [bit] = null,
	@AffinityContributionAvailabilityDetails [varchar] (4000) = null,
	@CashEquivalentTransferValue [money] = NULL,
	@TransferExpiryDate [date] = NULL,
	@PlanCurrency varchar(3) = null,
	@AgencyStatus varchar(50) null = null,
	@PensionArrangement varchar(100) = null,
	@CrystallisationStatus varchar (20) = null,
	@HistoricalCrystallisedPercentage decimal (10, 2) = null,
	@CurrentCrystallisedPercentage decimal (10, 2) = null,
	@CrystallisedPercentage decimal (10, 2) = null,
	@UncrystallisedPercentage decimal (10, 2) = null
AS  
-- Declarations  
DECLARE @PolicyBusinessId bigint = @FinalSalaryPensionPlansId, 
	@IsGuaranteed bit, @MaturityDate datetime,
	@PensionInfoId bigint, @ExtId bigint,
	@CurrentPolicyNumber varchar(50), @PolicyBusinessExtId bigint

-- Update Policy Business
SELECT  @IsGuaranteed = IsGuaranteedToProtectOriginalInvestment, @MaturityDate = MaturityDate, @CurrentPolicyNumber = PolicyNumber
FROM PolicyManagement..TPolicyBusiness 
WHERE PolicyBusinessId = @PolicyBusinessId

-- There are two UI sceens, that use this procedure: FinalSalary UI in Fact Find and Plan UI.
-- Final Salary fact find UI doesn't contain a PolicyNumber field and sends PolicyNumber = null to this procedure.
-- That is why we need to populate PocicyNumber with an actual value from database. Otherwise it will be set to null 
-- without user knowing about it.
-- If user deletes PolicyNumber on plan UI, then it sends PolicyNumber = '' (empty string) to this procedure,
-- so this fix doesn't prevent user from editing PolicyNumber on plan UI.
IF (@PolicyNumber IS NULL)
 SET @PolicyNumber =  @CurrentPolicyNumber

EXEC [SpNCustomUpdatePlanPolicyBusiness] @StampUser, @PolicyBusinessId, 
	@PolicyNumber, @DateJoined, @MaturityDate, @ProductName, @IsGuaranteed, @PlanCurrency = @PlanCurrency
  
-- Update Mortgage repay amounts
EXEC SpNCustomUpdateMortgageRepayAmounts @StampUser, @PolicyBusinessId, @MortgageRepayPercentage, @MortgageRepayAmount
  
-- Update the TPension record  
SELECT @PensionInfoId = PensionInfoId FROM PolicyManagement..TPensionInfo WHERE PolicyBusinessId = @PolicyBusinessId

-- We may need to create a pension info record if the plan was created outside fact find.
IF @PensionInfoId IS NULL
BEGIN
	INSERT INTO PolicyManagement..TPensionInfo (PolicyBusinessId, SRA, PensionableSalary, ExpectedYearsOfService, AccrualRate, IsCurrent, IsIndexed,ProspectivePensionAtRetirement,
	ProspectiveLumpSumAtRetirement, EarlyRetirementFactorNotes, DependantBenefits, IndexationNotes, ProspectivePensionAtRetirementLumpSumTaken, ServiceBenefitSpouseEntitled,
	YearsPurchaseAvailability, YearsPurchaseAvailabilityDetails, AffinityContributionAvailability, AffinityContributionAvailabilityDetails, CashEquivalentTransferValue, TransferExpiryDate,
	PensionArrangement, CrystallisationStatus, HistoricalCrystallisedPercentage, CurrentCrystallisedPercentage, CrystallisedPercentage, UncrystallisedPercentage)
	VALUES (@PolicyBusinessID, @NormalSchemeRetirementAge, @PensionableSalary, @ExpectedYearsOfService, @AccrualRate, @Preserved, @Indexed,@ProspectivePensionAtRetirement,
	@ProspectiveLumpSumAtRetirement, @EarlyRetirementFactorNotes, @DependantBenefits, @IndexationNotes, @ProspectivePensionAtRetirementLumpSumTaken, @DeathInServiceSpousalBenefits,
	@YearsPurchaseAvailability, @YearsPurchaseAvailabilityDetails, @AffinityContributionAvailability, @AffinityContributionAvailabilityDetails, @CashEquivalentTransferValue, @TransferExpiryDate,
	@PensionArrangement, @CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage, @UncrystallisedPercentage)

	SET @PensionInfoId = SCOPE_IDENTITY()  
	EXEC PolicyManagement..SpNAuditPensionInfo @StampUser, @PensionInfoId, 'C'
END
ELSE
BEGIN   
	EXEC PolicyManagement..SpNAuditPensionInfo @StampUser, @PensionInfoId, 'U'
	   
	UPDATE PolicyManagement..TPensionInfo  
	SET 
		SRA = @NormalSchemeRetirementAge,   
		PensionableSalary = @PensionableSalary,   
		ExpectedYearsOfService = @ExpectedYearsOfService,   
		AccrualRate = @AccrualRate,   
		IsCurrent =@Preserved,   
		IsIndexed = @Indexed,
		ConcurrencyId = ConcurrencyId + 1,
		ProspectivePensionAtRetirement = @ProspectivePensionAtRetirement,
		ProspectivePensionAtRetirementLumpSumTaken = @ProspectivePensionAtRetirementLumpSumTaken,
		ProspectiveLumpSumAtRetirement = @ProspectiveLumpSumAtRetirement,
		EarlyRetirementFactorNotes = @EarlyRetirementFactorNotes,
		DependantBenefits = @DependantBenefits,
		ServiceBenefitSpouseEntitled = @DeathInServiceSpousalBenefits,
		IndexationNotes = @IndexationNotes,
		YearsPurchaseAvailability = @YearsPurchaseAvailability,
		YearsPurchaseAvailabilityDetails = @YearsPurchaseAvailabilityDetails,
		AffinityContributionAvailability = @AffinityContributionAvailability,
		AffinityContributionAvailabilityDetails = @AffinityContributionAvailabilityDetails,
		CashEquivalentTransferValue = @CashEquivalentTransferValue, 
		TransferExpiryDate = @TransferExpiryDate,
		PensionArrangement = @PensionArrangement,
		CrystallisationStatus = @CrystallisationStatus,
		HistoricalCrystallisedPercentage = @HistoricalCrystallisedPercentage,
		CurrentCrystallisedPercentage = @CurrentCrystallisedPercentage,
		CrystallisedPercentage = @CrystallisedPercentage,
		UncrystallisedPercentage = @UncrystallisedPercentage 
	WHERE PensionInfoId = @PensionInfoId  
END

--Update Agency Status
SELECT @PolicyBusinessExtId = PBE.PolicyBusinessExtId
FROM PolicyManagement.dbo.TPolicyBusinessExt PBE
WHERE PBE.PolicyBusinessId = @PolicyBusinessId;

EXEC PolicyManagement.dbo.SpNAuditPolicyBusinessExt @StampUser, @PolicyBusinessExtId, 'U';

UPDATE PolicyManagement.dbo.TPolicyBusinessExt
SET AgencyStatus = @AgencyStatus
WHERE PolicyBusinessExtId = @PolicyBusinessExtId;

-- Update Commissions DnPolicyMatching  
EXEC PolicyManagement..SpNCustomManageDnPolicyMatching @PolicyBusinessId, @StampUser  
  
-- Ext fields    
DECLARE @FinalSalaryPensionsPlanFFExtId bigint, @CurrentEmployer varchar(255)  
SELECT @FinalSalaryPensionsPlanFFExtId = FinalSalaryPensionsPlanFFExtId, @CurrentEmployer = Employer 
FROM TFinalSalaryPensionsPlanFFExt WHERE PolicyBusinessId = @PolicyBusinessId

IF @FinalSalaryPensionsPlanFFExtId IS NULL  
BEGIN  
	INSERT INTO TFinalSalaryPensionsPlanFFExt(PolicyBusinessId, Employer, ConcurrencyId)  
	VALUES (@FinalSalaryPensionPlansId, @Employer, 1)  

	SET @FinalSalaryPensionsPlanFFExtId = SCOPE_IDENTITY()
	EXEC SpNAuditFinalSalaryPensionsPlanFFExt @StampUser, @FinalSalaryPensionsPlanFFExtId, 'C'
END  
ELSE IF ISNULL(@CurrentEmployer, '') != ISNULL(@Employer, '')
BEGIN  
	EXEC SpNAuditFinalSalaryPensionsPlanFFExt @StampUser, @FinalSalaryPensionsPlanFFExtId, 'U'

	UPDATE TFinalSalaryPensionsPlanFFExt   
	SET Employer = @Employer, ConcurrencyId = ConcurrencyId + 1
	WHERE PolicyBusinessId = @FinalSalaryPensionPlansId
END

-- Add notes
EXEC [dbo].[SpNCustomCreateOrUpdatePlanAdditionalNotes] @PolicyBusinessId, @AdditionalNotes, @StampUser
GO