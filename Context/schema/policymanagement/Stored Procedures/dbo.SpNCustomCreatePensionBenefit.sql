
-- drop Procedure SpNCustomCreatePensionBenefit

Create Procedure SpNCustomCreatePensionBenefit
	@StampUser int,
	@RefPlanType2ProdSubTypeId int,
	@TenantId int,
	@OwnerPartyId int,
	@PlanId	int,
	@PensionCommencementLumpSum	money,
	@PCLSPaidById int,
	@GADMaximumIncomeLimit money,
	@GuaranteedMinimumIncome money,
	@GADCalculationDate	datetime,
	@IsCapitalValueProtected bit,
	@CapitalValueProtectedAmount money,
	@LumpSumDeathBenefitAmount money,
	@IsSpousesBenefit bit,
	@IsOverlap bit,
	@GuaranteedPeriod int,
	@IsProportion bit
As

exec factfind..[SpNCustomCreatePlanBenefits]
	@StampUser = @StampUser,
	@TenantId = @TenantId,
	@PolicyBusinessId = @PlanId,
	@CRMContactId = @OwnerPartyId,
	@CRMContactId2 = null,
	@RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId,
	@PensionCommencementLumpSum = @PensionCommencementLumpSum,
	@PCLSPaidById = @PCLSPaidById,
	@GADMaximumIncomeLimit = @GADMaximumIncomeLimit,
	@GuaranteedMinimumIncome = @GuaranteedMinimumIncome,
	@GADCalculationDate = @GADCalculationDate,
	@IsCapitalValueProtected = @IsCapitalValueProtected,
	@CapitalValueProtectedAmount = @CapitalValueProtectedAmount,
	@LumpSumDeathBenefitAmount = @LumpSumDeathBenefitAmount,
	@IsSpousesBenefit = @IsSpousesBenefit,
	@IsOverlap = @IsOverlap,
	@GuaranteedPeriod = @GuaranteedPeriod,
	@IsProportion = @IsProportion,
	@LifeAssured = ''



/*
--------------------------------
----- TESTING ------------------
--------------------------------	

begin tran

Declare @ProtectionId int, @BenefitId int, @AssuredLifeId int
Select @ProtectionId = Max(ProtectionId) From TProtection
Select @BenefitId = Max(BenefitId) from TBenefit
Select @AssuredLifeId = Max(AssuredLifeId) from TAssuredLife


exec SpNCustomCreatePensionBenefit
	@StampUser =9999,
	@RefPlanType2ProdSubTypeId =110,
	@TenantId  = 10155,
	@OwnerPartyId =111,
	@PlanId	= 222,
	@PensionCommencementLumpSum	= 50000,
	@PCLSPaidById = null,
	@GADMaximumIncomeLimit = null,
	@GuaranteedMinimumIncome = null,
	@GADCalculationDate	= null,
	@IsCapitalValueProtected = null,
	@CapitalValueProtectedAmount = null,
	@LumpSumDeathBenefitAmount = null,
	@IsSpousesBenefit= null,
	@IsOverlap = null,
	@GuaranteedPeriod = null,
	@IsProportion = null

Select * From TProtection Where ProtectionId > IsNull(@ProtectionId, 0)
Select * from TBenefit Where BenefitId > IsNull(@BenefitId, 0)
Select * from TAssuredLife Where AssuredLifeId > IsNull(@AssuredLifeId, 0)

rollback tran


*/
	