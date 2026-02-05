SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateProtectionPlans]       
	@StampUser varchar(255),
	@ProtectionPlansId bigint, -- policyBusinessId      
	@CRMContactId bigint, -- this is always the primary fact find client.
	@Owner varchar(255) = null,      
	@SellingAdviser bigint = null,  -- Not used for update.
	@RefPlanType2ProdSubTypeId bigint, 
	@PolicyNumber varchar(50) = null,      
	@ProtectionPlanPurpose varchar(255) = null,      
	@ProtectionStartDate datetime = null,      
	@MaturityDate datetime = null,      
	@RegularPremium money = null,      
	@PremiumFrequency varchar(255) = null,      
	@LifeCoverAmount money = null,
	@CriticalIllnessAmount money = null,      
	@SumAssured money = null,
	@BenefitAmount money = null,      
	@BenefitFrequencyId bigint = null,
	@LifeAssured varchar(255) = null,	-- Personal FF
	@LifeAssuredId bigint = null,		-- Corporate FF
	@RefPaymentBasisId int = null,      
	@RefBenefitPeriodId int = null,      
	@BenefitDeferredPeriod int = null,      
	@DeferredPeriodIntervalId bigint = null,
	@AssignedInTrust bit = null,      
	@ConcurrencyId bigint = null, -- Not used 
	@PlanPurposeId bigint = null,
	@IsForProtectionShortfallCalculation bit = null,
	@OtherBenefitPeriodText varchar(255) = null,
	@ProductName varchar(200) = null,
	@GMPAmount money = null,
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
	@RelatedToProductId INT = null,
	@PensionArrangement varchar(100) = null,
	@CrystallisationStatus varchar (20) = null,
	@HistoricalCrystallisedPercentage decimal (10, 2) = null,
	@CurrentCrystallisedPercentage decimal (10, 2) = null,
	@CrystallisedPercentage decimal (10, 2) = null,
	@UncrystallisedPercentage decimal (10, 2) = null
AS      
-----------------------------------------------
-- Declarations
-----------------------------------------------
DECLARE @PolicyBusinessId bigint = @ProtectionPlansId,
	@ProtectionId bigint, @BenId1 bigint, @BenId2 bigint, @AssuredId bigint, @GiId bigint,
	@IsGuaranteed bit, @PolicyBusinessExtId bigint, @WrapperPolicyBusinessId bigint

------------------------------------------------------
-- Update Policy Business
------------------------------------------------------	
SELECT  @IsGuaranteed = IsGuaranteedToProtectOriginalInvestment
FROM PolicyManagement..TPolicyBusiness 
WHERE PolicyBusinessId = @PolicyBusinessId

/*PlanPurpose is not passed to the SP from the new FF code, instead PlanPurposeId is passed
so getting the planpurpose text based on planPurposeId.*/
IF(@PlanPurposeId IS NOT NULL)
  SET @ProtectionPlanPurpose = (SELECT Descriptor
                              FROM PolicyManagement..TPlanPurpose 
                              WHERE PlanPurposeId=@PlanPurposeId)
                                     
EXEC [SpNCustomUpdatePlanPolicyBusiness] @StampUser, @PolicyBusinessId, 
	@PolicyNumber, @ProtectionStartDate, @MaturityDate, @ProductName, @IsGuaranteed, @PlanCurrency = @PlanCurrency

-----------------------------------------------
-- Update or add the plan purpose.      
-----------------------------------------------
EXEC FactFind.dbo.SpNCustomUpdatePlanPurpose @PolicyBusinessId, @ProtectionPlanPurpose, @StampUser, @PlanPurposeId

-----------------------------------------------  
-- Update DnPolicyMatching      
-----------------------------------------------
EXEC PolicyManagement..SpNCustomManageDnPolicyMatching @PolicyBusinessId, @StampUser      

--Update Agency Status
SELECT @PolicyBusinessExtId = PBE.PolicyBusinessExtId
FROM PolicyManagement.dbo.TPolicyBusinessExt PBE
WHERE PBE.PolicyBusinessId = @PolicyBusinessId;

EXEC PolicyManagement.dbo.SpNAuditPolicyBusinessExt @StampUser, @PolicyBusinessExtId, 'U';

UPDATE PolicyManagement.dbo.TPolicyBusinessExt
SET AgencyStatus = @AgencyStatus
WHERE PolicyBusinessExtId = @PolicyBusinessExtId;

----------------------------------------------------------------    
---- Add Pension Info
----------------------------------------------------------------    
EXEC [SpNCustomUpdatePlanPensionInfo] @StampUser, @PolicyBusinessId, null, null, null, null, null, null, null, null, null, null, null, null, null, @DeathBenefits
									, null, null, null, null, null, 
									@CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
									@UncrystallisedPercentage, @PensionArrangement  		  
-----------------------------------------------  
-- Benefits      
----------------------------------------------- 
SELECT 
	@ProtectionId = ProtectionId
FROM
	PolicyManagement..TProtection	
WHERE
	PolicyBusinessId = @PolicyBusinessId	

SELECT @BenId1 = BenefitId FROM PolicyManagement..TAssuredLife WHERE ProtectionId = @ProtectionId AND OrderKey = 1
SELECT @BenId2 = BenefitId FROM PolicyManagement..TAssuredLife WHERE ProtectionId = @ProtectionId AND OrderKey = 2

EXEC PolicyManagement..SpNAuditBenefit @StampUser, @BenId1, 'U'
EXEC PolicyManagement..SpNAuditBenefit @StampUser, @BenId2, 'U'

UPDATE 
	PolicyManagement..TBenefit
SET
	BenefitAmount = @BenefitAmount, 
	BenefitDeferredPeriod = @BenefitDeferredPeriod, 
	RefFrequencyId = @BenefitFrequencyId, 
	RefBenefitPeriodId = @RefBenefitPeriodId,
	OtherBenefitPeriodText = @OtherBenefitPeriodText,
	DeferredPeriodIntervalId = @DeferredPeriodIntervalId,
	ConcurrencyId = ConcurrencyId + 1,
	SplitBenefitAmount = @SplitBenefitAmount,
	RefSplitFrequencyId = @RefSplitFrequencyId,
	SplitBenefitDeferredPeriod = @SplitBenefitDeferredPeriod,
	SplitDeferredPeriodIntervalId = @SplitDeferredPeriodIntervalId
WHERE
	BenefitId IN (@BenId1, @BenId2) 	
				
-----------------------------------------------  
-- Protection
----------------------------------------------- 
EXEC PolicyManagement..SpNAuditProtection @StampUser, @ProtectionId, 'U'

UPDATE PolicyManagement..TProtection
SET
	InTrust = @AssignedInTrust, 
	LifeCoverSumAssured = @LifeCoverAmount, 
	CriticalIllnessSumAssured = @CriticalIllnessAmount, 
	PaymentBasisId = @RefPaymentBasisId,
	IsForProtectionShortfallCalculation = @IsForProtectionShortfallCalculation,
	PtdCoverAmount = @PtdCoverAmount,
	ProtectionPayoutType = @ProtectionPayoutType,
	IncomePremiumStructure = @IncomePremiumStructure,
	CriticalIllnessPremiumStructure = @CriticalIllnessPremiumStructure,
	LifeCoverPremiumStructure = @LifeCoverPremiumStructure,
	PtdCoverPremiumStructure = @PtdCoverPremiumStructure,
	SeverityCoverAmount = @SeverityCoverAmount,
	SeverityCoverPremiumStructure = @SeverityCoverPremiumStructure,
	ExpensePremiumStructure = @ExpensePremiumStructure,
	ConcurrencyId = ConcurrencyId + 1
WHERE
	ProtectionId = @ProtectionId
	
-----------------------------------------------  
-- GI
----------------------------------------------- 
IF @RefPlanType2ProdSubTypeId IN (110, 58, 111, 123, 1059, 109) -- Payment Protection. 
BEGIN
	SELECT @GiId = GeneralInsuranceDetailId 
		FROM PolicyManagement..TGeneralInsuranceDetail 
		WHERE ProtectionId = @ProtectionId AND ISNULL(SumAssured, -1) != ISNULL(@SumAssured, -1)

	IF @GiId IS NOT NULL
	BEGIN
		EXEC PolicyManagement..SpNAuditGeneralInsuranceDetail @StampUser, @GiId, 'U'

		UPDATE PolicyManagement..TGeneralInsuranceDetail
		SET
			SumAssured = @SumAssured,
			ConcurrencyId = ConcurrencyId + 1
		WHERE
			GeneralInsuranceDetailId = @GiId
	END					
END

-------------------------------------------------------------------------------
-- Update wrapper plan when held in super is selected in IO for AU Region
-------------------------------------------------------------------------------

IF (@RelatedToProductId > 0 AND @PolicyBusinessId IS NOT NULL) 
BEGIN
	SELECT @WrapperPolicyBusinessId = WrapperPolicyBusinessId  FROM [PolicyManagement].[dbo].[TWrapperPolicyBusiness] WHERE PolicyBusinessId = @PolicyBusinessId
    IF @WrapperPolicyBusinessId IS NOT NULL
    BEGIN
        UPDATE [PolicyManagement].[dbo].[TWrapperPolicyBusiness]
        SET ParentPolicyBusinessId = @RelatedToProductId,
            ConcurrencyId = ConcurrencyId + 1
        WHERE PolicyBusinessId = @PolicyBusinessId;

		EXEC policymanagement..SpNAuditWrapperPolicyBusiness @StampUser, @WrapperPolicyBusinessId, 'U'
    END
    ELSE
    BEGIN
        INSERT INTO [PolicyManagement].[dbo].[TWrapperPolicyBusiness]
            ([ParentPolicyBusinessId], [PolicyBusinessId], [ConcurrencyId])
        VALUES
            (@RelatedToProductId, @PolicyBusinessId, 1);

		SELECT @WrapperPolicyBusinessId = WrapperPolicyBusinessId  FROM [PolicyManagement].[dbo].[TWrapperPolicyBusiness] WHERE PolicyBusinessId = @PolicyBusinessId
		EXEC policymanagement..SpNAuditWrapperPolicyBusiness @StampUser, @WrapperPolicyBusinessId, 'C'
    END
END
-------------------------------------------------------------------------------
-- Remove wrapper plan when held in super is changed to No in IO for AU Region
-------------------------------------------------------------------------------
IF (@RelatedToProductId = 0 AND @PolicyBusinessId IS NOT NULL AND @CrystallisationStatus IS NULL) 
BEGIN
	SELECT @WrapperPolicyBusinessId = WrapperPolicyBusinessId  FROM [PolicyManagement].[dbo].[TWrapperPolicyBusiness] WHERE PolicyBusinessId = @PolicyBusinessId
	IF @WrapperPolicyBusinessId IS NOT NULL
	BEGIN
		EXEC policymanagement..SpNAuditWrapperPolicyBusiness @StampUser, @WrapperPolicyBusinessId, 'D'
		DELETE FROM [PolicyManagement].[dbo].[TWrapperPolicyBusiness]
		WHERE [PolicyBusinessId] = @PolicyBusinessId
	END
END
GO