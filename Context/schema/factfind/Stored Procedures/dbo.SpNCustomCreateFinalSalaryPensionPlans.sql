SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateFinalSalaryPensionPlans]   
	@StampUser varchar(255),  
	@CRMContactId bigint,  
	@Owner varchar(255),
	@RefProdProviderId bigint, 
	@CurrentUserDateTime datetime,
	@Timezone varchar(100),
	@Employer varchar(255) = null,  
	@NormalSchemeRetirementAge int = null,  
	@AccrualRate int = null,  
	@DateJoined datetime = null,  
	@ExpectedYearsOfService int = null,  
	@PensionableSalary money = null,  
	@Indexed bit=NULL,  
	@Preserved bit=NULL,  
	@SellingAdviser bigint,  
	@PolicyNumber varchar(50)=null,  
	@MortgageRepayPercentage money = null,
	@MortgageRepayAmount money = null,
	@ProductName varchar(200)=null,
	@GMPAmount money = null,
	@SplitTemplateGroupId int = null,  
	@TemplateGroupType varchar(255) = null,
	@ProspectivePensionAtRetirement money =null,
	@ProspectiveLumpSumAtRetirement	money=null,
	@EarlyRetirementFactorNotes varchar(1000) = null,
	@DependantBenefits [varchar] (100)= null,
	@IndexationNotes varchar(1000)= null,
	@AdditionalNotes varchar(1000) = null,
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
DECLARE @CRMContactId2 bigint, @PolicyBusinessId bigint, @IndigoClientId bigint  
-- Is there a client 2?  
SET @CRMContactId2 = (SELECT CRMContactId2 FROM TFactFind WHERE CRMContactId1 = @CRMContactId)  
  
-- Get the indigoClientId, use the CRMContactId to get it  
SET @IndigoClientId = (SELECT IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId) 
  
-- Create the basic plan data, this will return a PolicyBusinessId  
EXEC SpNCustomCreatePlan  @CRMContactId, @CRMContactId2, @CurrentUserDateTime, @Timezone, 'Final Salary Scheme',NULL, @PolicyNumber, 
	@Owner, null, null, null, @IndigoClientId, @ProductName , @StampUser, @DateJoined, @SellingAdviser, @PolicyBusinessId OUTPUT,
	@RefProdProviderId = @RefProdProviderId, @MortgageRepayAmount = @MortgageRepayAmount, @MortgageRepayPercentage = @MortgageRepayPercentage, @PlanCurrency = @PlanCurrency,
	@AgencyStatus = @AgencyStatus

-- Create a TPension record  
DECLARE @PensionInfoId bigint  

INSERT INTO PolicyManagement..TPensionInfo (PolicyBusinessId, SRA, PensionableSalary, ExpectedYearsOfService, AccrualRate, IsCurrent, IsIndexed, 
GMPAmount,ProspectivePensionAtRetirement,ProspectiveLumpSumAtRetirement, EarlyRetirementFactorNotes, DependantBenefits, IndexationNotes, 
ProspectivePensionAtRetirementLumpSumTaken, ServiceBenefitSpouseEntitled, YearsPurchaseAvailability, YearsPurchaseAvailabilityDetails, AffinityContributionAvailability, AffinityContributionAvailabilityDetails, CashEquivalentTransferValue, TransferExpiryDate,
PensionArrangement, CrystallisationStatus, HistoricalCrystallisedPercentage, CurrentCrystallisedPercentage, CrystallisedPercentage, UncrystallisedPercentage)
VALUES (@PolicyBusinessID, @NormalSchemeRetirementAge, @PensionableSalary, @ExpectedYearsOfService, @AccrualRate, @Preserved, @Indexed, @GMPAmount,@ProspectivePensionAtRetirement,
@ProspectiveLumpSumAtRetirement, @EarlyRetirementFactorNotes, @DependantBenefits, @IndexationNotes, @ProspectivePensionAtRetirementLumpSumTaken, @DeathInServiceSpousalBenefits,
@YearsPurchaseAvailability, @YearsPurchaseAvailabilityDetails, @AffinityContributionAvailability, @AffinityContributionAvailabilityDetails, @CashEquivalentTransferValue, @TransferExpiryDate,
@PensionArrangement, @CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage, @UncrystallisedPercentage)

SET @PensionInfoId = SCOPE_IDENTITY()  
EXEC PolicyManagement..SpNAuditPensionInfo @StampUser, @PensionInfoId, 'C'
  
-- Ext fields  
DECLARE @FinalSalaryPensionsPlanFFExtId bigint  

INSERT INTO TFinalSalaryPensionsPlanFFExt(PolicyBusinessId, Employer, ConcurrencyId)  
VALUES (@PolicyBusinessId, @Employer, 1)  

SET @FinalSalaryPensionsPlanFFExtId = SCOPE_IDENTITY()  
EXEC SpNAuditFinalSalaryPensionsPlanFFExt @StampUser, @FinalSalaryPensionsPlanFFExtId, 'C'

--Add Splits for the plan
IF((@SplitTemplateGroupId IS NOT NULL) AND (@SplitTemplateGroupId > 0) AND (@TemplateGroupType IS NOT NULL))
BEGIN
	EXEC [SpNCreateSplitTemplatesForPlans] @IndigoClientId,@CRMContactId, @PolicyBusinessId, @SellingAdviser,@SplitTemplateGroupId,@TemplateGroupType
END

-- Add notes
EXEC [dbo].[SpNCustomCreateOrUpdatePlanAdditionalNotes] @PolicyBusinessId, @AdditionalNotes, @StampUser

SELECT @PolicyBusinessId as FinalSalaryPensionPlansId  
GO

