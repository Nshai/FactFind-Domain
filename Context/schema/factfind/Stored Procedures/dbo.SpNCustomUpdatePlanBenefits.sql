SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdatePlanBenefits]
	@StampUser varchar(50),
	@PolicyBusinessId bigint,
	@TenantId bigint,
	@RefPlanType2ProdSubTypeId bigint,
	@CRMContactId bigint,
	@PensionCommencementLumpSum money = null,
	@PCLSPaidById bigint = null,
	@GADMaximumIncomeLimit money = null,
	@GuaranteedMinimumIncome money = null,
	@GADCalculationDate datetime = null,
	@NextReviewDate datetime = null,
	@IsCapitalValueProtected bit = null,
	@CapitalValueProtectedAmount money = null,
	@InTrust bit= null,
	@LumpSumDeathBenefitAmount money = null,
	@IsSpousesBenefit bit = null,
	@SpousesOrDependentsPercentage decimal(5,2) = null,
	@IsOverlap bit = null,
	@GuaranteedPeriod int = null,
	@IsProportion bit = null,
	@IsProtectedPCLS bit = null
AS
DECLARE @ProtectionId bigint, @BenefitId bigint

-------------------------------------------------
-- Find current protection details for this plan
-------------------------------------------------
SELECT @ProtectionId = ProtectionId
FROM PolicyManagement..TProtection
WHERE PolicyBusinessId = @PolicyBusinessId

-------------------------------------------------
-- If no Protection is available then call the Create procedure instead.
-------------------------------------------------
IF @ProtectionId IS NULL BEGIN
	EXEC SpNCustomCreatePlanBenefits @StampUser, @TenantId, @PolicyBusinessId,
		@CRMContactId, NULL, @RefPlanType2ProdSubTypeId,
		NULL, NULL, NULL, NULL, NULL, NULL, @CRMContactId, NULL, NULL, NULL,
		@InTrust, @PensionCommencementLumpSum, @PCLSPaidById,
		@GADMaximumIncomeLimit, @GuaranteedMinimumIncome, @GADCalculationDate, @NextReviewDate,
		@IsCapitalValueProtected, @CapitalValueProtectedAmount, @LumpSumDeathBenefitAmount, @IsSpousesBenefit,
		@SpousesOrDependentsPercentage, @IsOverlap, @GuaranteedPeriod, @IsProportion,NULL,NULL,NULL,@IsProtectedPCLS

	RETURN;
END

-------------------------------------------------
-- Find benefit details
-------------------------------------------------
SELECT @BenefitId = BenefitId FROM PolicyManagement..TAssuredLife WHERE ProtectionId = @ProtectionId AND OrderKey = 1
-------------------------------------------------
-- If no BenefitId is found then assume that is non-assuredLife plan type
-------------------------------------------------
IF @BenefitId IS NULL BEGIN
	SELECT @BenefitId = BenefitId FROM PolicyManagement..TBenefit WHERE PolicyBusinessId = @PolicyBusinessId
END

EXEC PolicyManagement..SpNAuditBenefit @StampUser, @BenefitId, 'U'
UPDATE
	PolicyManagement..TBenefit
SET
	PensionCommencementLumpSum = @PensionCommencementLumpSum,
	PCLSPaidById = @PCLSPaidById,
	IsCapitalValueProtected = @IsCapitalValueProtected,
	CapitalValueProtectedAmount = @CapitalValueProtectedAmount,
	GADMaximumIncomeLimit = @GADMaximumIncomeLimit,
	GADCalculationDate = @GADCalculationDate,
	GuaranteedMinimumIncome = @GuaranteedMinimumIncome,
	LumpSumDeathBenefitAmount = @LumpSumDeathBenefitAmount,
	IsSpousesBenefit = @IsSpousesBenefit,
	SpousesOrDependentsPercentage = @SpousesOrDependentsPercentage,
	IsOverlap = @IsOverlap,
	GuaranteedPeriod = @GuaranteedPeriod,
	IsProportion = @IsProportion,
	ConcurrencyId = ConcurrencyId + 1,
	IsProtectedPCLS = @IsProtectedPCLS
WHERE
	BenefitId = @BenefitId

-----------------------------------------------
-- Update Protection
-----------------------------------------------
EXEC PolicyManagement..SpNAuditProtection @StampUser, @ProtectionId, 'U'

IF @RefPlanType2ProdSubTypeId NOT IN (1173,1174,1175,1176)
	UPDATE PolicyManagement..TProtection
	SET
		InTrust = @InTrust,
		ReviewDate = @NextReviewDate,
		ConcurrencyId = ConcurrencyId + 1
	WHERE
		ProtectionId = @ProtectionId
ELSE
	UPDATE PolicyManagement..TProtection
	SET
		InTrust = @InTrust,
		ConcurrencyId = ConcurrencyId + 1
	WHERE
		ProtectionId = @ProtectionId
GO
