SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreatePlanBenefits]
	@StampUser varchar(50),
	@TenantId bigint,
	@PolicyBusinessId bigint,
	@CRMContactId bigint,
	@CRMContactId2 bigint,
	@RefPlanType2ProdSubTypeId bigint,
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
	@InTrust bit = null,
	@PensionCommencementLumpSum money = null,
	@PCLSPaidById bigint = null,
	@GADMaximumIncomeLimit money = null,
	@GuaranteedMinimumIncome money = null,
	@GADCalculationDate datetime = null,
	@NextReviewDate datetime = null,
	@IsCapitalValueProtected bit = null,
	@CapitalValueProtectedAmount money = null,
	@LumpSumDeathBenefitAmount money = null,
	@IsSpousesBenefit bit = null,
	@SpousesOrDependentsPercentage decimal(5,2) = null,
	@IsOverlap bit = null,
	@GuaranteedPeriod int = null,
	@IsProportion bit = null,
	@DeferredPeriodIntervalId bigint = null,
	@IsForProtectionShortfallCalculation bit = null,
	@OtherBenefitPeriodText varchar(255) = null,
	@IsProtectedPCLS bit = null,
	@SplitBenefitAmount money = null,
	@RefSplitFrequencyId int = null,
	@SplitBenefitDeferredPeriod int = null,
	@SplitDeferredPeriodIntervalId int = null,
	@PtdCoverAmount money = null,
	@ProtectionPayoutType varchar(25) = null,
	@IncomePremiumStructure varchar(25) = null,
	@CriticalIllnessPremiumStructure varchar(25) = null,
	@LifeCoverPremiumStructure varchar(25) = null,
	@PtdCoverPremiumStructure varchar(25) = null,
	@SeverityCoverAmount money = null,
	@SeverityCoverPremiumStructure varchar(25) = null,
	@ExpensePremiumStructure varchar(25) = null
AS
DECLARE @ProtectionId bigint, @BenefitOptions int,
	@BenId1 bigint, @BenId2 bigint, @AssuredId bigint, @Discriminator bigint, @GenInsId bigint,
	@PartyId bigint, @LifeCover money, @RefPlanTypeId bigint, @RefInsuranceCoverCategoryId bigint

-------------------------------------------------------------------------------
-- Protection Plan Discriminator used by NIO.
-------------------------------------------------------------------------------
SELECT @RefPlanTypeId = RefPlanTypeId FROM PolicyManagement..TRefPlanType2ProdSubType WHERE RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId
-- Most protection plans
SELECT @Discriminator = 51, @RefInsuranceCoverCategoryId = 5
-- Payment Protection. ASU, Redundancy etc.
IF @RefPlanType2ProdSubTypeId IN (110, 58, 111, 123, 1059, 109)
	SET @Discriminator = 55
-- Health. Dental, Long Term Care, Locum, Healthcare.
ELSE IF @RefPlanTypeId IN (97, 116, 117, 59, 111, 1021, 53, 58)
	SELECT @Discriminator = 47, @RefInsuranceCoverCategoryId = 6

-------------------------------------------------------------------------------
-- Create a TProtection record
-------------------------------------------------------------------------------
INSERT INTO PolicyManagement..TProtection (
	IndigoClientId, PolicyBusinessId, RefPlanSubCategoryId, InTrust, ReviewDate,
	LifeCoverSumAssured, CriticalIllnessSumAssured, PaymentBasisId, IsForProtectionShortfallCalculation, PtdCoverAmount,
	ProtectionPayoutType, IncomePremiumStructure, CriticalIllnessPremiumStructure, LifeCoverPremiumStructure, PtdCoverPremiumStructure,
	SeverityCoverAmount, SeverityCoverPremiumStructure, ExpensePremiumStructure)
VALUES (@TenantId, @PolicyBusinessId, @Discriminator, @InTrust, @NextReviewDate,
	@LifeCoverAmount, @CriticalIllnessAmount, @RefPaymentBasisId, @IsForProtectionShortfallCalculation, @PtdCoverAmount,
	@ProtectionPayoutType, @IncomePremiumStructure, @CriticalIllnessPremiumStructure, @LifeCoverPremiumStructure, @PtdCoverPremiumStructure,
	@SeverityCoverAmount, @SeverityCoverPremiumStructure, @ExpensePremiumStructure)

SET @ProtectionId = SCOPE_IDENTITY()
EXEC PolicyManagement..SpNAuditProtection @StampUser, @ProtectionId, 'C'

-------------------------------------------------------------------------------
-- Create a Benefit record (1 for each life assured)
-------------------------------------------------------------------------------
-- For Term (Convertible) plan types the Convertible benefit option should be set.
IF @RefPlanType2ProdSubTypeId = 103 -- Term (Convertible)
	SET @BenefitOptions = 1
-- For Term (Renewable) plan types the Renewable benefit option should be set.
IF @RefPlanType2ProdSubTypeId = 1023 -- Term (Renewable)
	SET @BenefitOptions = 2

INSERT INTO PolicyManagement..TBenefit (
	BenefitAmount, BenefitDeferredPeriod, RefFrequencyId, RefBenefitPeriodId, IndigoClientId, BenefitOptions,
	PensionCommencementLumpSum, PCLSPaidById, IsCapitalValueProtected, CapitalValueProtectedAmount,
	GADMaximumIncomeLimit, GADCalculationDate, GuaranteedMinimumIncome, LumpSumDeathBenefitAmount,
	IsSpousesBenefit, SpousesOrDependentsPercentage, IsOverlap, GuaranteedPeriod, IsProportion, DeferredPeriodIntervalId,OtherBenefitPeriodText,
	IsProtectedPCLS,SplitBenefitAmount,RefSplitFrequencyId,SplitBenefitDeferredPeriod,SplitDeferredPeriodIntervalId,PolicyBusinessId)
VALUES (
	@BenefitAmount, @BenefitDeferredPeriod, @BenefitFrequencyId, @RefBenefitPeriodId, @TenantId, @BenefitOptions,
	@PensionCommencementLumpSum, @PCLSPaidById, @IsCapitalValueProtected, @CapitalValueProtectedAmount,
	@GADMaximumIncomeLimit, @GADCalculationDate, @GuaranteedMinimumIncome, @LumpSumDeathBenefitAmount,
	@IsSpousesBenefit, @SpousesOrDependentsPercentage, @IsOverlap, @GuaranteedPeriod, @IsProportion, @DeferredPeriodIntervalId, @OtherBenefitPeriodText,
	@IsProtectedPCLS,@SplitBenefitAmount,@RefSplitFrequencyId,@SplitBenefitDeferredPeriod,@SplitDeferredPeriodIntervalId,@PolicyBusinessId)

SET @BenId1 = SCOPE_IDENTITY()
EXEC PolicyManagement..SpNAuditBenefit @StampUser, @BenId1, 'C'

-- Add benefits for Client 2
IF @CRMContactId2 > 0 AND @LifeAssured = 'Joint' BEGIN
	INSERT INTO PolicyManagement..TBenefit (
		BenefitAmount, BenefitDeferredPeriod, RefFrequencyId, RefBenefitPeriodId, IndigoClientId, BenefitOptions,
		PensionCommencementLumpSum, PCLSPaidById, IsCapitalValueProtected, CapitalValueProtectedAmount,
		GADMaximumIncomeLimit, GADCalculationDate, GuaranteedMinimumIncome, LumpSumDeathBenefitAmount,
		IsSpousesBenefit, SpousesOrDependentsPercentage, IsOverlap, GuaranteedPeriod, IsProportion, DeferredPeriodIntervalId, OtherBenefitPeriodText, IsProtectedPCLS, PolicyBusinessId)
	VALUES (
		@BenefitAmount, @BenefitDeferredPeriod, @BenefitFrequencyId, @RefBenefitPeriodId, @TenantId, @BenefitOptions,
		@PensionCommencementLumpSum, @PCLSPaidById, @IsCapitalValueProtected, @CapitalValueProtectedAmount,
		@GADMaximumIncomeLimit, @GADCalculationDate, @GuaranteedMinimumIncome, @LumpSumDeathBenefitAmount,
		@IsSpousesBenefit, @SpousesOrDependentsPercentage, @IsOverlap, @GuaranteedPeriod, @IsProportion, @DeferredPeriodIntervalId, @OtherBenefitPeriodText, @IsProtectedPCLS, @PolicyBusinessId)

	SET @BenId2 = SCOPE_IDENTITY()
	EXEC PolicyManagement..SpNAuditBenefit @StampUser, @BenId2, 'C'
END

-------------------------------------------------------------------------------
-- Create life assured details (1 for each life assured)
-------------------------------------------------------------------------------
IF @LifeAssuredId IS NOT NULL -- Corporate FF / Annuities
	SET @PartyId = @LifeAssuredId
ELSE
	SET @PartyId = @CRMContactId -- Personal FF / Money Purchase

-- Update Life Assured to client 2?
IF @CRMContactId2 > 0 AND @LifeAssured = 'Client 2'
	SET @PartyId = @CRMContactId2
IF @LifeAssured IS NOT NULL OR @LifeAssuredId IS NOT NULL
INSERT INTO policymanagement.dbo.TAssuredLife (PartyId, BenefitId, IndigoClientId, ProtectionId, OrderKey)
VALUES (@PartyId, @BenId1, @TenantId, @ProtectionId, 1)

SET @AssuredId = SCOPE_IDENTITY()
EXEC PolicyManagement..SpNAuditAssuredLife @StampUser, @AssuredId, 'C'

-- Client 2
IF @CRMContactId2 > 0 AND @LifeAssured = 'Joint' BEGIN
	INSERT INTO PolicyManagement..TAssuredLife (PartyId, BenefitId, IndigoClientId, ProtectionId, OrderKey)
	VALUES (@CRMContactId2, @BenId2, @TenantId,@ProtectionId, 2)

	SET @AssuredId = SCOPE_IDENTITY()
	EXEC PolicyManagement..SpNAuditAssuredLife @StampUser, @AssuredId, 'C'
END

-------------------------------------------------------------------------------      
-- General Insurance / Payment Protection Stuff.
-------------------------------------------------------------------------------
IF @Discriminator IN (55, 47) BEGIN
	-- Add Sum Assured Amounts
	INSERT INTO PolicyManagement..TGeneralInsuranceDetail (ProtectionId, RefInsuranceCoverCategoryId, SumAssured,
		AdditionalCoverAmount, Owner2PercentageOfSumAssured, ExcessAmount, InsuranceCoverOptions, RefInsuranceCoverAreaId,
		RefInsuranceCoverTypeId, IsCoverNoteIssued)
	VALUES (@ProtectionId, @RefInsuranceCoverCategoryId, @SumAssured, 0, 0, 0, 0, 0, 0, 0)

	SET @GenInsId  = SCOPE_IDENTITY()
	EXEC PolicyManagement..SpNAuditGeneralInsuranceDetail @StampUser, @GenInsId, 'C'
END
GO