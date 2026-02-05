SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrievePersonalAnnuityPlans]
(
  @IndigoClientId bigint,
  @UserId bigint,
  @FactFindId bigint,
  @CurrentUserDate DATETIME,
  @ExcludePlanPurposes BIT = 0,
  @ParentPolicyBusinessId bigint = null
)
As
Begin
SET NOCOUNT ON
SET DATEFORMAT dmy
DECLARE 
	@CRMContactId bigint, @CRMContactId2 bigint, @AdviserId bigint, @AdviserCRMId bigint, @AdviserName varchar(255),
	@PreExistingAdviserId bigint, @PreExistingAdviserName varchar(255), @PreExistingAdviserCRMId bigint,
	@NewId bigint, @IncludeTopups bit, @TenantId bigint,
	@AdviserUserId bigint, @AdviserGroupId bigint, @IncomeReplacementRate smallint, @UserIncomeReplacementRate smallint

---------------------------------------------------------------------------------
-- Get some initial settings  
---------------------------------------------------------------------------------
 Exec dbo.SpNCustomRetrievePersonalDataInitialSettings @IndigoClientId, @UserId, @FactFindId, @ExcludePlanPurposes,@CRMContactId OutPut,
													   @CRMContactId2 OutPut, @AdviserId OutPut, @AdviserCRMId OutPut, @AdviserName OutPut,
													   @PreExistingAdviserId OutPut, @PreExistingAdviserName OutPut, @PreExistingAdviserCRMId OutPut,
													   @NewId OutPut, @IncludeTopups OutPut, @TenantId OutPut,
													   @AdviserUserId OutPut, @AdviserGroupId OutPut, @IncomeReplacementRate OutPut, @UserIncomeReplacementRate OutPut



-- Table for Plan Types Details
DECLARE @PlanDescription TABLE
(
 PolicyBusinessId bigint not null PRIMARY KEY,
 PolicyDetailId bigint not null,
 CRMContactId bigint not null,
 CRMContactId2 bigint null,
 [Owner] varchar(16) not null,
 OwnerCount int not null,
 RefPlanType2ProdSubTypeId bigint not NULL,
 PlanType varchar(128) not null,
 UnderlyingPlanType varchar(128) not null,
 RefProdProviderId bigint not null,
 Provider varchar(128) not null,
 PolicyNumber varchar(64) null,
 AgencyStatus varchar(50) null,
 StartDate datetime null,
 MaturityDate datetime null,
 StatusDate datetime null,
 Term tinyint null,
 RegularPremium money null,
 ActualRegularPremium money null,
 TotalLumpSum money null,
 TotalPremium money null,
 Frequency varchar(32) null,
 Valuation money null,
 CurrentValue money null,
 ValuationDate datetime,
 ProductName varchar(255) null,
 RefPlanTypeId bigint,
 SellingAdviserId bigint,
 SellingAdviserName varchar(255),
 PlanPurpose varchar(255),
 PlanPurposeId bigint null,
 ParentPolicyBusinessId bigint,
 ExcludeValuation bit,
 ConcurrencyId bigint null,
 PlanStatus varchar(50) null,
 MortgageRepayPercentage money null,
 MortgageRepayAmount money null,
 [IsGuaranteedToProtectOriginalInvestment] bit null,
 PlanCurrency varchar(3) null,
 SequentialRef varchar(50) null,
 IsProviderManaged bit null
)

-- Basic Plan Details
INSERT INTO @PlanDescription
 Select * from dbo.FnCustomGetPlanDescription(@CRMContactId, @CRMContactId2, @TenantId, @ExcludePlanPurposes, @IncludeTopups)

-- Update WRAPs so their valuation's are excluded if they have child plans
UPDATE A
SET
	ExcludeValuation = 1
FROM
	-- The A's are the WRAPs
	@PlanDescription A
	-- The B's are child plans who's parent also appears in our list.
	JOIN @PlanDescription B ON B.ParentPolicyBusinessId = A.PolicyBusinessId
WHERE
	A.UnderlyingPlanType = 'WRAP'
	AND B.CurrentValue != 0	-- Child plan must have a value.

-- Get a list of plan ids for these clients
DECLARE @PlanList TABLE (BusinessId bigint PRIMARY KEY, DetailId bigint)
INSERT INTO @PlanList
SELECT DISTINCT
 PB.PolicyBusinessId, PB.PolicyDetailId
FROM
  PolicyManagement..TPolicyOwner PO WITH(NOLOCK)
  JOIN PolicyManagement..TPolicyBusiness PB WITH(NOLOCK) ON PB.PolicyDetailId = PO.PolicyDetailId
WHERE
 CRMContactId IN (@CRMContactId, @CRMContactId2)


 -- Contributions
DECLARE @Contributions TABLE (PolicyBusinessId bigint, TypeId int, ContributorTypeId int, Amount money,
	RefFrequencyId int, FrequencyName varchar(50), StartDate datetime, StopDate datetime, FirstId bigint)
-- Lump Sum amounts.
INSERT INTO @Contributions (PolicyBusinessId, TypeId, ContributorTypeId, Amount, FrequencyName, FirstId, StartDate)
SELECT PolicyBusinessId, RefContributionTypeId, RefContributorTypeId, SUM(Amount), 'Single', MIN(PolicyMoneyInId), MIN(StartDate)
FROM PolicyManagement..TPolicyMoneyIn
WHERE PolicyBusinessId IN (SELECT BusinessId FROM @PlanList) AND (StartDate < @CurrentUserDate Or StartDate Is Null) AND RefContributionTypeId != 1
GROUP BY PolicyBusinessId, RefContributionTypeId, RefContributorTypeId

-- Regular
INSERT INTO @Contributions (PolicyBusinessId, TypeId, ContributorTypeId, Amount, RefFrequencyId, FrequencyName, StartDate, StopDate)
SELECT PolicyBusinessId, 1, RefContributorTypeId, Amount, A.RefFrequencyId, RF.FrequencyName, StartDate, StopDate
FROM 
	PolicyManagement..TPolicyMoneyIn A
	JOIN PolicyManagement..TRefFrequency RF ON RF.RefFrequencyId = A.RefFrequencyId
WHERE 
	PolicyMoneyInId IN (
		SELECT MIN(PolicyMoneyInId)
		FROM PolicyManagement..TPolicyMoneyIn
		WHERE PolicyBusinessId IN (SELECT BusinessId FROM @PlanList)
			AND @CurrentUserDate BETWEEN StartDate AND ISNULL(StopDate, @CurrentUserDate) AND RefContributionTypeId = 1
		GROUP BY PolicyBusinessId, RefContributorTypeId)

DECLARE @PlanDesc TABLE
(
 PolicyBusinessId bigint not null PRIMARY KEY,
 PolicyDetailId bigint not null,
 CRMContactId bigint not null,
 CRMContactId2 bigint null,
 [Owner] varchar(16) not null,
 SellingAdviserId bigint,
 SellingAdviserName varchar(255),
 RefPlanTypeId bigint not NULL,
 PlanType varchar(128) not null,
 RefProdProviderId bigint not null,
 Provider varchar(128) not null,
 PolicyNumber varchar(64) null,
 AgencyStatus varchar(50) null,
 PolicyStartDate datetime null,
 TotalPurchaseAmount money null,
 PremiumStartDate datetime null,
 CapitalElement money null,
 AssumedGrowthRatePercentage decimal null,
 RefAnnuityPaymentTypeId int null,
 IncomeAmount money null,
 IncomeFrequencyId bigint null,
 IncomeEffectiveDate datetime null,
 PensionCommencementLumpSum money null,
 PCLSPaidById int null,
 IsCapitalValueProtected bit null,
 CapitalValueProtectedAmount money null,
 IsSpousesBenefit bit null,
 SpousesOrDependentsPercentage decimal null,
 GuaranteedPeriod int null,
 IsOverlap bit null,
 IsProportion bit null,
 ConcurrencyId bigint null,
 MortgageRepayPercentage money null,
 MortgageRepayAmount money null,
 PlanStatus varchar(50) null,
 ProductName varchar(255) null,
 IsWrapperFg bit null,
 GMPAmount money null,
 DeathBenefits  money null,
 AdditionalNotes varchar(1000) null,
 PlanCurrency varchar(3) null,
 SequentialRef varchar(50) null,
 IsProviderManaged bit null
)

INSERT INTO @PlanDesc
SELECT
	P.PolicyBusinessId,
	P.PolicyDetailId,
	P.CRMContactId,
	P.CRMContactId2,
	P.[Owner],
	P.SellingAdviserId,
	P.SellingAdviserName,
	P.RefPlanType2ProdSubTypeId AS RefPlanTypeId,
	P.PlanType,
	P.RefProdProviderId,
	P.Provider,
	P.PolicyNumber,
	P.AgencyStatus,
	P.StartDate AS PolicyStartDate,
	LC.Amount AS TotalPurchaseAmount,
	LC.StartDate AS PremiumStartDate,
	PD.CapitalElement,
	PD.AssumedGrowthRatePercentage,
	PD.RefAnnuityPaymentTypeId,
	PMO.Amount AS IncomeAmount,
	PMO.RefFrequencyId AS IncomeFrequencyId,
	PMO.PaymentStartDate AS IncomeEffectiveDate,
	COALESCE(B.PensionCommencementLumpSum, B2.PensionCommencementLumpSum) AS PensionCommencementLumpSum,
	COALESCE(B.PCLSPaidById, B2.PCLSPaidById) AS PCLSPaidById,
	COALESCE(B.IsCapitalValueProtected, B2.IsCapitalValueProtected) AS IsCapitalValueProtected,
	COALESCE(B.CapitalValueProtectedAmount, B2.CapitalValueProtectedAmount) AS CapitalValueProtectedAmount,
	COALESCE(B.IsSpousesBenefit, B2.IsSpousesBenefit) AS IsSpousesBenefit,
	COALESCE(B.SpousesOrDependentsPercentage, B2.SpousesOrDependentsPercentage) AS SpousesOrDependentsPercentage,
	COALESCE(B.GuaranteedPeriod, B2.GuaranteedPeriod) AS GuaranteedPeriod,
	COALESCE(B.IsOverlap, B2.IsOverlap) AS IsOverlap,
	COALESCE(B.IsProportion, B2.IsProportion) AS IsProportion,
	P.ConcurrencyId,
	P.MortgageRepayPercentage,
	P.MortgageRepayAmount,
	P.PlanStatus,
	P.ProductName,
	RPT.IsWrapperFg,
	TPI.GMPAmount,
	TPI.DeathBenefit as DeathBenefits,
	PBE.AdditionalNotes,
	p.PlanCurrency,
	P.SequentialRef,
	P.IsProviderManaged
FROM
	@PlanDescription P
	JOIN FactFind..TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = P.RefPlanType2ProdSubTypeId
	JOIN PolicyManagement..TPolicyDetail PD ON PD.PolicyDetailId = P.PolicyDetailId
	LEFT JOIN PolicyManagement..TProtection PROT ON PROT.PolicyBusinessId = P.PolicyBusinessId
	LEFT JOIN PolicyManagement..TAssuredLife AL ON AL.ProtectionId = PROT.ProtectionId AND (AL.PartyId = @CRMContactId OR AL.PartyId = @CRMContactId2) AND AL.OrderKey = 1
	LEFT JOIN PolicyManagement..TBenefit B ON B.BenefitId = AL.BenefitId
	LEFT JOIN (
		SELECT
		 B3.[PensionCommencementLumpSum]
		,B3.[IsSpousesBenefit]
		,B3.[SpousesOrDependentsPercentage]
		,B3.[GuaranteedPeriod]
		,B3.[IsProportion]
		,B3.[PCLSPaidById]
		,B3.[IsCapitalValueProtected]
		,B3.[CapitalValueProtectedAmount]
		,B3.[IsOverlap]
		,B3.[PolicyBusinessId]
		FROM policymanagement..TBenefit AS B3
		LEFT JOIN PolicyManagement..TAssuredLife AS AL2 ON B3.BenefitId = AL2.BenefitId
		WHERE AL2.BenefitId IS NULL) AS B2 ON b2.PolicyBusinessId = p.PolicyBusinessId
	LEFT JOIN PolicyManagement..TPensionInfo TPI ON TPI.PolicyBusinessId = P.PolicyBusinessId
	LEFT JOIN PolicyManagement..TPolicyBusinessExt PBE ON PBE.PolicyBusinessId = P.PolicyBusinessId
	-- Lump Sum Contributions (we need to include transfers and rebates to match core system)
	LEFT JOIN (
		SELECT PolicyBusinessId, SUM(Amount) AS Amount, MIN(StartDate) AS StartDate
		FROM @Contributions
		WHERE TypeId != 1
		GROUP BY PolicyBusinessId) AS LC ON LC.PolicyBusinessId = P.PolicyBusinessId
	-- Last current Regular Withdrawal
	LEFT JOIN (
		SELECT MAX(PolicyMoneyOutId) AS Id, PolicyBusinessId
		FROM PolicyManagement..TPolicyMoneyOut
		WHERE 
			PolicyBusinessId IN (SELECT PolicyBusinessId FROM @PlanList)
			AND RefWithdrawalTypeId = 1	-- regular
			AND @CurrentUserDate BETWEEN PaymentStartDate AND ISNULL(PaymentStopDate, @CurrentUserDate) -- Current
		GROUP BY PolicyBusinessId
	) AS FirstOut ON FirstOut.PolicyBusinessId = P.PolicyBusinessId
	LEFT JOIN PolicyManagement..TPolicyMoneyOut PMO ON PMO.PolicyMoneyOutId = FirstOut.Id
	LEFT JOIN policymanagement..TRefPlanType2ProdSubType PTPS ON P.RefPlanType2ProdSubTypeId = PTPS.RefPlanType2ProdSubTypeId 
	LEFT JOIN policymanagement..TRefPlanType RPT ON RPT.RefPlanTypeId = PTPS.RefPlanTypeId
WHERE
	(PTS.Section = 'Annuities' AND @ParentPolicyBusinessId IS NULL) OR @ParentPolicyBusinessId IS NOT NULL

---holding table to identify plans where IsWrapperFg = 0/1 and WrapPlan = 0/x - where 'x' is the wrapl its linked to 
DECLARE @PlanGrouping TABLE 
(
 PolicyBusinessId int, 
 IsWrapperPlan bit, 
 WrapPlan int, 
 TopupMasterPolicyBusinessId int Default(0), 
 WrapPlanName varchar(128) null)

--Identify IsWrapper Plan
INSERT INTO @PlanGrouping (PolicyBusinessId, IsWrapperPlan, WrapPlan)
SELECT 
	PD.PolicyBusinessId, IsWrapperPlan = 1, WrapPlan = 0
FROM  
	@PlanDesc PD 
	LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper WITH(NOLOCK) ON wrapper.PolicyBusinessId = PD.PolicyBusinessId   
WHERE 
	PD.IsWrapperFg = 1
	AND wrapper.PolicyBusinessId IS NULL

--Identify NON-IsWrapper Plan
INSERT INTO @PlanGrouping (PolicyBusinessId, IsWrapperPlan, WrapPlan)
SELECT 
	PD.PolicyBusinessId, IsWrapperPlan = 0, WrapPlan = 0
FROM
	@PlanDesc PD
	LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper1 WITH(NOLOCK) ON wrapper1.PolicyBusinessId = PD.PolicyBusinessId
	LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper2 WITH(NOLOCK) ON wrapper2.ParentPolicyBusinessId = PD.PolicyBusinessId
	LEFT JOIN policymanagement..TStatusHistory TSH ON TSH.PolicyBusinessId = wrapper1.ParentPolicyBusinessId
	LEFT JOIN policymanagement..TStatus TS ON TS.StatusId = TSH.StatusId
WHERE 
	(wrapper1.PolicyBusinessId IS NULL OR TS.IntelligentOfficeStatusType = 'Deleted') 
	AND wrapper2.ParentPolicyBusinessId IS NULL
	AND PD.IsWrapperFg = 0

--Identify wrap sub plan types
INSERT INTO @PlanGrouping (PolicyBusinessId, IsWrapperPlan, WrapPlan, WrapPlanName)
SELECT 
	PD.PolicyBusinessId, 
	IsWrapperPlan = 0, 
	WrapPlan = ISNULL(Wrapper1.ParentPolicyBusinessId, 0),
	ParentPlan.PlanTypeName
FROM
	@PlanDesc PD
	LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper1 WITH(NOLOCK) ON wrapper1.PolicyBusinessId = PD.PolicyBusinessId    
	LEFT JOIN policymanagement..TStatusHistory TSH ON TSH.PolicyBusinessId = wrapper1.ParentPolicyBusinessId
	LEFT JOIN policymanagement..TStatus TS ON TS.StatusId = TSH.StatusId
	LEFT JOIN (
		SELECT 
			PRPT.PlanTypeName, PPB.PolicyBusinessId 
		FROM 
			policymanagement..TPolicyBusiness PPB 
			INNER JOIN policymanagement..TPolicyDetail PPD ON PPD.PolicyDetailId = PPB.PolicyDetailId
			INNER JOIN policymanagement..TPlanDescription PPDes ON PPDes.PlanDescriptionId = PPD.PlanDescriptionId
			INNER JOIN policymanagement..TRefPlanType2ProdSubType PPTPS ON PPDes.RefPlanType2ProdSubTypeId = PPTPS.RefPlanType2ProdSubTypeId   
			INNER JOIN policymanagement..TRefPlanType PRPT ON PRPT.RefPlanTypeId = PPTPS.RefPlanTypeId
			INNER JOIN policymanagement..TRefProdProvider PP ON PP.RefProdProviderId = PPDes.RefProdProviderId
			INNER JOIN crm..TCRMContact crm ON crm.CRMContactId = PP.CRMContactId 
		WHERE PRPT.PlanTypeName = 'Wrap'
			) AS ParentPlan
			ON ParentPlan.PolicyBusinessId = wrapper1.ParentPolicyBusinessId

WHERE 
	Wrapper1.ParentPolicyBusinessId IS NOT NULL 
	AND ParentPlan.PlanTypeName = 'Wrap'
	AND (TS.IntelligentOfficeStatusType = 'In force' OR TS.IntelligentOfficeStatusType = 'Paid Up') 
	AND TSH.CurrentStatusFG = 1

--Identify TopUp plans
UPDATE a
SET a.TopupMasterPolicyBusinessId = pb.TopupMasterPolicyBusinessId
FROM @PlanGrouping a 
INNER JOIN policymanagement..TPolicyBusiness pb ON pb.PolicyBusinessId = a.PolicyBusinessId

--Group Topup plans under their respective 'WRAP' plan types
UPDATE a
SET 
	a.WrapPlan = wp2topupplan.wrapplan
FROM  @PlanGrouping a
INNER JOIN (
	--Identify wrap plan linked to a topup master plan
	SELECT topupplans.TopupMasterPolicyBusinessId, topupplans.PolicyBusinessId, a.WrapPlan
	FROM @PlanGrouping a
	INNER JOIN (
		--Identify topup plans 
		SELECT PolicyBusinessId, TopupMasterPolicyBusinessId
		FROM @PlanGrouping
		WHERE WrapPlan = 0 AND TopupMasterPolicyBusinessId IS NOT NULL
		) topupplans ON a.PolicyBusinessId = topupplans.TopupMasterPolicyBusinessId
	) wp2topupplan ON wp2topupplan.PolicyBusinessId = a.PolicyBusinessId

IF (ISNULL(@ParentPolicyBusinessId ,0) <= 0)
BEGIN
SELECT                               
	PD.PolicyBusinessId AS AnnuityPlanId,
	PD.PolicyBusinessId,
	PD.PolicyDetailId,
	PD.CRMContactId,
	PD.CRMContactId2,
	PD.[Owner],
	PD.SellingAdviserId,
	PD.SellingAdviserName,
	PD.RefPlanTypeId,
	PD.PlanType AS PlanTypeName,
	PD.RefProdProviderId,
	PD.Provider AS ProviderName,
	PD.PolicyNumber,
	PD.AgencyStatus,
	PD.PolicyStartDate,
	PD.TotalPurchaseAmount,
	PD.PremiumStartDate,
	PD.CapitalElement,
	PD.AssumedGrowthRatePercentage,
	PD.RefAnnuityPaymentTypeId,
	PD.IncomeAmount,
	PD.IncomeFrequencyId,
	PD.IncomeEffectiveDate,
	PD.PCLSPaidById,
	PD.IsCapitalValueProtected,
	PD.CapitalValueProtectedAmount,
	PD.IsSpousesBenefit,
	PD.SpousesOrDependentsPercentage,
	PD.GuaranteedPeriod,
	PD.IsOverlap,
	PD.IsProportion,
	PD.ConcurrencyId,
	PD.MortgageRepayPercentage,
	PD.MortgageRepayAmount,
	PD.PlanStatus,
	PD.ProductName,
	PG.IsWrapperPlan AS IsWrapper,
	PG.WrapPlan,
	PG.WrapPlanName,
	PD.GMPAmount,
	PD.DeathBenefits,
	PD.AdditionalNotes,
	PD.PlanCurrency,
	PD.SequentialRef,
	PD.IsProviderManaged
	FROM 
		@PlanDesc PD
		LEFT JOIN @PlanGrouping PG ON PD.PolicyBusinessId = PG.PolicyBusinessId
END
 ELSE
 BEGIN
 SELECT                               
	PD.PolicyBusinessId AS AnnuityPlanId,
	PD.PolicyBusinessId,
	PD.PolicyDetailId,
	PD.CRMContactId,
	PD.CRMContactId2,
	PD.[Owner],
	PD.SellingAdviserId,
	PD.SellingAdviserName,
	PD.RefPlanTypeId,
	PD.PlanType AS PlanTypeName,
	PD.RefProdProviderId,
	PD.Provider AS ProviderName,
	PD.PolicyNumber,
	PD.AgencyStatus,
	PD.PolicyStartDate,
	PD.TotalPurchaseAmount,
	PD.PremiumStartDate,
	PD.CapitalElement,
	PD.AssumedGrowthRatePercentage,
	PD.RefAnnuityPaymentTypeId,
	PD.IncomeAmount,
	PD.IncomeFrequencyId,
	PD.IncomeEffectiveDate,
	PD.PCLSPaidById,
	PD.IsCapitalValueProtected,
	PD.CapitalValueProtectedAmount,
	PD.IsSpousesBenefit,
	PD.SpousesOrDependentsPercentage,
	PD.GuaranteedPeriod,
	PD.IsOverlap,
	PD.IsProportion,
	PD.ConcurrencyId,
	PD.MortgageRepayPercentage,
	PD.MortgageRepayAmount,
	PD.PlanStatus,
	PD.ProductName,
	PG.IsWrapperPlan AS IsWrapper,
	PG.WrapPlan,
	PG.WrapPlanName,
	PD.GMPAmount,
	PD.DeathBenefits,
	PD.AdditionalNotes,
	PD.PlanCurrency,
	PD.SequentialRef,
	PD.IsProviderManaged,
	TPI.PensionArrangement,
	TPI.CrystallisationStatus,
	TPI.HistoricalCrystallisedPercentage,
	TPI.CurrentCrystallisedPercentage,
	TPI.CrystallisedPercentage,
	TPI.UncrystallisedPercentage
	FROM 
		@PlanDesc PD
		JOIN Policymanagement..TWrapperPolicyBusiness wrapper WITH(NOLOCK) ON wrapper.PolicyBusinessId = PD.PolicyBusinessId
		LEFT JOIN @PlanGrouping PG ON PD.PolicyBusinessId = PG.PolicyBusinessId
		LEFT JOIN PolicyManagement..TPensionInfo TPI ON TPI.PolicyBusinessId = PD.PolicyBusinessId	 
	WHERE wrapper.ParentPolicyBusinessId = @ParentPolicyBusinessId
 END
SET NOCOUNT OFF
End
GO
