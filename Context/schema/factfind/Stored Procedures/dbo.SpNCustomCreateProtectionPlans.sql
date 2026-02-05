SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateProtectionPlans]       
	@StampUser varchar(255),  
	@CRMContactId bigint,      
	@Owner varchar(255),      
	@SellingAdviser bigint,      
	@RefPlanType2ProdSubTypeId bigint,    
	@RefProdProviderId bigint,
	@CurrentUserDateTime datetime,
	@Timezone varchar(100),
	@PolicyNumber varchar(50)=null,    
	@ProtectionPlanPurpose varchar(255)=NULL,      
	@ProtectionStartDate datetime=null,    
	@MaturityDate datetime = null,      
	@RegularPremium money = null,      
	@PremiumFrequency varchar(50) = null,      
	@LifeCoverAmount money = null,
	@CriticalIllnessAmount money = null,      
	@SumAssured money = null,
	@BenefitAmount money = null,    
	@BenefitFrequencyId bigint = null,
	@LifeAssured varchar(255) = null,	-- Used by Personal FF
	@LifeAssuredId bigint = null,		-- Used by Corporate FF
	@RefPaymentBasisId int = null,      
	@RefBenefitPeriodId int = null,      
	@BenefitDeferredPeriod int = null, 
	@DeferredPeriodIntervalId bigint = null,     
	@AssignedInTrust bit = null,
	@PlanPurposeId bigint = null,
	@IsForProtectionShortfallCalculation bit = null,
	@OtherBenefitPeriodText varchar(255) = null,
	@ProductName varchar(200) = null,
	@RetirementAge int= null,
	@Indexed bit= null,    
	@Preserved bit= null,    
	@GMPAmount money = null,
	@SplitTemplateGroupId int = null,  
	@TemplateGroupType varchar(255) = null,  
	@SplitBenefitAmount money = null,
	@RefSplitFrequencyId int = null ,
	@SplitBenefitDeferredPeriod int = null,
	@SplitDeferredPeriodIntervalId int = null,
	@DeathBenefits [money] = null,
	@PlanCurrency varchar(3) = null,
	@AgencyStatus varchar(50) null = null,
	@PtdCoverAmount money = null,
	@ProtectionPayoutType varchar(25) = null,
	@IncomePremiumStructure varchar(25) = null,
	@CriticalIllnessPremiumStructure varchar(25) = null,
	@LifeCoverPremiumStructure varchar(25) = null,
	@PtdCoverPremiumStructure varchar(25) = null,
	@SeverityCoverAmount money = null,
	@SeverityCoverPremiumStructure varchar(25) = null,
	@ExpensePremiumStructure varchar(25) = null,
	@RelatedToProductId  INT = null,
	@RefContributorTypeId INT = null,
	@PensionArrangement varchar(100) = null,
	@CrystallisationStatus varchar (20) = null,
	@HistoricalCrystallisedPercentage decimal (10, 2) = null,
	@CurrentCrystallisedPercentage decimal (10, 2) = null,
	@CrystallisedPercentage decimal (10, 2) = null,
	@UncrystallisedPercentage decimal (10, 2) = null
AS
-------------------------------------------------------------------------------            
-- Declarations    
-------------------------------------------------------------------------------            
DECLARE @TenantId bigint, @PolicyBusinessId bigint, @CRMContactId2 bigint, @ProtectionId bigint,
	@BenId1 bigint, @BenId2 bigint, @AssuredId bigint, @Discriminator bigint, @GenInsId bigint,
	@PartyId bigint, @LifeCover money, @RefPlanTypeId bigint, @RefInsuranceCoverCategoryId bigint, @WrapperPolicyBusinessId bigint

-------------------------------------------------------------------------------            
-- Get tenantId and Joint FF details.
-------------------------------------------------------------------------------      
-- Get the indigoClientId, use the CRMContactId to get it      
SELECT @TenantId = IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId
-- pick up second life for this ff.
SELECT @CRMContactId2 = ISNULL(CRMContactId2, 0) FROM TFactFind WHERE CRMContactId1 = @CRMContactId

/*PlanPurpose is not passed to the SP from the new FF code, instead PlanPurposeId is passed
so getting the planpurpose text based on planPurposeId.*/
IF(@PlanPurposeId IS NOT NULL)
  SET @ProtectionPlanPurpose = (SELECT Descriptor
                              FROM PolicyManagement..TPlanPurpose 
                              WHERE IndigoClientId=@TenantId AND 
                                     PlanPurposeId=@PlanPurposeId)
-------------------------------------------------------------------------------            
-- Create the basic plan data, this will return a PolicyBusinessId      
-------------------------------------------------------------------------------      
exec SpNCustomCreatePlan @CRMContactId, @CRMContactId2, @CurrentUserDateTime, @Timezone, NULL, @ProtectionPlanPurpose, 
	@PolicyNumber, @Owner, @RegularPremium, @PremiumFrequency, @MaturityDate, @TenantId, @ProductName, @StampUser, 
	@ProtectionStartDate, @SellingAdviser, @PolicyBusinessId OUTPUT, @RefPlanType2ProdSubTypeId, @RefProdProviderId,@PlanPurposeId = @PlanPurposeId,
	@PlanCurrency=@PlanCurrency, @AgencyStatus = @AgencyStatus, @RefContributorTypeId = @RefContributorTypeId

-- Return PolicyBusinessId to FF
SELECT @PolicyBusinessId as ProtectionPlansId      

-------------------------------------------------------------------------------            
-- Create benefits
-------------------------------------------------------------------------------           
EXEC SpNCustomCreatePlanBenefits @StampUser, @TenantId, @PolicyBusinessId, @CRMContactId, @CRMContactId2, 
	@RefPlanType2ProdSubTypeId, @LifeCoverAmount, @CriticalIllnessAmount, @SumAssured, @BenefitAmount, 
	@BenefitFrequencyId, @LifeAssured, @LifeAssuredId, @RefPaymentBasisId, @RefBenefitPeriodId, @BenefitDeferredPeriod, 
	@AssignedInTrust, @DeferredPeriodIntervalId = @DeferredPeriodIntervalId, @IsForProtectionShortfallCalculation = @IsForProtectionShortfallCalculation,
	@OtherBenefitPeriodText = @OtherBenefitPeriodText, @SplitBenefitAmount = @SplitBenefitAmount,@RefSplitFrequencyId=@RefSplitFrequencyId,
	@SplitBenefitDeferredPeriod=@SplitBenefitDeferredPeriod,@SplitDeferredPeriodIntervalId=@SplitDeferredPeriodIntervalId, @PtdCoverAmount=@PtdCoverAmount,
	@ProtectionPayoutType = @ProtectionPayoutType, @IncomePremiumStructure = @IncomePremiumStructure, @CriticalIllnessPremiumStructure = @CriticalIllnessPremiumStructure,
	@LifeCoverPremiumStructure = @LifeCoverPremiumStructure, @PtdCoverPremiumStructure = @PtdCoverPremiumStructure, @SeverityCoverAmount = @SeverityCoverAmount,
	@SeverityCoverPremiumStructure = @SeverityCoverPremiumStructure, @ExpensePremiumStructure = @ExpensePremiumStructure

----------------------------------------------------------------    
---- Add Pension Info
----------------------------------------------------------------    
IF(@GMPAmount IS NOT NULL)
BEGIN
	EXEC [SpNCustomCreatePlanPensionInfo] @StampUser, @PolicyBusinessId, @RetirementAge, @Preserved, @Indexed, @GMPAmount, 
	null, null, null, null, null, null, null, null, null, 
	@DeathBenefits, null, null, null, null, null, 
	@CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement
END
ELSE
BEGIN
	EXEC [SpNCustomCreatePlanPensionInfo] @StampUser, @PolicyBusinessId, null, null, null, null, null, null, null, null, null, null, null, null, null, @DeathBenefits,
	null, null, null, null, null, 
	@CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement
END

IF((@SplitTemplateGroupId IS NOT NULL) AND (@SplitTemplateGroupId > 0) AND (@TemplateGroupType IS NOT NULL))
BEGIN
	EXEC SpNCreateSplitTemplatesForPlans @TenantId,@CRMContactId, @PolicyBusinessId, @SellingAdviser,@SplitTemplateGroupId,@TemplateGroupType
END

-------------------------------------------------------------------------------
-- Link wrapper plan when held in super is selected in IO for AU Region
-------------------------------------------------------------------------------

IF (@RelatedToProductId > 0 AND @PolicyBusinessId IS NOT NULL) 
BEGIN
	INSERT INTO [PolicyManagement].[dbo].[TWrapperPolicyBusiness]
	([ParentPolicyBusinessId]
	,[PolicyBusinessId]
	,[ConcurrencyId])
	VALUES
		(@RelatedToProductId, @PolicyBusinessId, 1)

	SELECT @WrapperPolicyBusinessId = WrapperPolicyBusinessId  FROM [PolicyManagement].[dbo].[TWrapperPolicyBusiness] WHERE PolicyBusinessId = @PolicyBusinessId
	IF @WrapperPolicyBusinessId IS NOT NULL
	BEGIN
		EXEC policymanagement..SpNAuditWrapperPolicyBusiness @StampUser, @WrapperPolicyBusinessId, 'C'
	END
END

GO

