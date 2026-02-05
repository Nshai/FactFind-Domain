SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrievePersonalPensionPlans] 
(
  @IndigoClientId bigint,                                
  @UserId bigint,                                
  @FactFindId bigint ,  
  @ParentPolicyBusinessId bigint = null,  
  @ExcludePlanPurposes BIT = 0,
  @CurrentUserDate datetime
)
As
Begin
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE   
 @CRMContactId bigint, @CRMContactId2 bigint, @AdviserId bigint, @AdviserCRMId bigint, @AdviserName varchar(255),  
 @PreExistingAdviserId bigint, @PreExistingAdviserName varchar(255), @PreExistingAdviserCRMId bigint,                    
 @NewId bigint, @IncludeTopups bit, @TenantId bigint,  @Now datetime = @CurrentUserDate,
 @AdviserUserId bigint, @AdviserGroupId bigint, @IncomeReplacementRate smallint, @UserIncomeReplacementRate smallint, 
  @PolicyBusinessId Bigint, @IsInvestmentPlan bigint = 0, @RegularContribution varchar(50) = 'Regular',
 @TransferContribution varchar(50) = 'Transfer', @LumpSumContribution varchar(50) = 'Lump Sum',
 @SelfContributor varchar(50) = 'Self', @EmployerContributor varchar(50) = 'Employer'
 
  
---------------------------------------------------------------------------------  
-- Get some initial settings  
---------------------------------------------------------------------------------  
 Exec dbo.SpNCustomRetrievePersonalDataInitialSettings @IndigoClientId, @UserId, @FactFindId, @ExcludePlanPurposes,@CRMContactId OutPut, 
													   @CRMContactId2 OutPut, @AdviserId OutPut, @AdviserCRMId OutPut, @AdviserName OutPut,  
													   @PreExistingAdviserId OutPut, @PreExistingAdviserName OutPut, @PreExistingAdviserCRMId OutPut,                    
													   @NewId OutPut, @IncludeTopups OutPut, @TenantId OutPut,  
													   @AdviserUserId OutPut, @AdviserGroupId OutPut, @IncomeReplacementRate OutPut, @UserIncomeReplacementRate OutPut
      
    
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
                       
                            
-- Basic Plan Details   
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
 Insert into @PlanDescription
 Select * from dbo.FnCustomGetPlanDescription(@CRMContactId, @CRMContactId2, @TenantId, @ExcludePlanPurposes, @IncludeTopups)

 DECLARE @PlanDesc TABLE                                
( 
 PersonalPensionPlanId bigint not null,                               
 PolicyBusinessId bigint not null,                                
 PolicyDetailId bigint not null,                                
 CRMContactId bigint not null,                                
 CRMContactId2 bigint null,                                
 [Owner] varchar(16) not null,
 SellingAdviserId bigint,                                
 SellingAdviserName varchar(255),                                     
 RefPlanTypeId bigint not NULL,                    
 PlanType varchar(255),
 RefProdProviderId bigint not null,
 Provider varchar(255),
 PolicyNumber varchar(64) null,
 AgencyStatus varchar(50) null,
 PolicyStartDate datetime null,
 RetirementAge int null,
 SelfContributionAmount money null,
 EmployerContributionAmount money null,
 RefContributionFrequencyId int null,
 TransferContribution money null,
 LumpSumContribution money null,
 Valuation money null,
 ValuationDate datetime,
 PensionCommencementLumpSum money null,
 PCLSPaidById bigint null,
 GADMaximumIncomeLimit money null,
 GuaranteedMinimumIncome money null,
 GADCalculationDate datetime,
 NextReviewDate datetime,
 IsCapitalValueProtected bit null,
 CapitalValueProtectedAmount money null,
 Indexed bit null,                     
 Preserved bit null,
 LumpSumDeathBenefitAmount money null,
 InTrust bit null,
 PremiumAmount money null,
 PremiumFrequencyId int null,
 PremiumStartDate datetime,
 ConcurrencyId bigint null,
 MortgageRepayPercentage money null,   
 MortgageRepayAmount money null,
 PlanStatus varchar(50) null,
 ProductName varchar(255) null,
 IsWrapperFg bit null,
 IsProtectedPCLS bit null,
 GMPAmount money null,
 [EnhancedTaxFreeCash] [varchar] (100) null,
 [GuaranteedAnnuityRate] [varchar] (100) null,
 [ApplicablePenalties] [varchar] (100) null,
 [EfiLoyaltyTerminalBonus] [varchar] (100) null,
 [GuaranteedGrowthRate] [varchar] (100) null,
 [OptionsAvailableAtRetirement] [varchar] (1000) null,
 [OtherBenefitsAndMaterialFeatures] [varchar] (1000) null,
 [AdditionalNotes] [varchar] (1000) null,
 [LifetimeAllowanceUsed] [decimal] (5, 2) null,
 [DeathInServiceSpousalBenefits] [money] null,
 [DeathBenefits] [money] null,
 [IsLifeStylingStrategy] BIT NULL,
 [LifeStylingStrategyDetail] [varchar] (4000),
 [PlanCurrency] varchar(3) null,
 [TaxedPensionAmount] [money] null,
 [UntaxedPensionAmount] [money] null,
 [SequentialRef] varchar(50) null,
 [IsProviderManaged] bit null,
 [CrystallisationStatus] Varchar(20) null,
 [HistoricalCrystallisedPercentage] [decimal] (10, 2) null,
 [CurrentCrystallisedPercentage] [decimal] (10, 2) null,
 [CrystallisedPercentage] [decimal] (10, 2) null,
 [UncrystallisedPercentage] [decimal] (10, 2) null,
 [PensionArrangement] [varchar] (100) null
 )

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

-- Contributions
DECLARE @Contributions TABLE (PolicyBusinessId bigint, TypeId int, ContributorTypeId int, Amount money, 
	RefFrequencyId int, FrequencyName varchar(50), StartDate datetime, StopDate datetime, FirstId bigint)
-- Lump Sum amounts.
INSERT INTO @Contributions (PolicyBusinessId, TypeId, ContributorTypeId, Amount, FrequencyName, FirstId) 
SELECT PolicyBusinessId, RefContributionTypeId, RefContributorTypeId, SUM(Amount), 'Single', MIN(PolicyMoneyInId) AS FirstId
FROM PolicyManagement..TPolicyMoneyIn 
WHERE PolicyBusinessId IN (SELECT BusinessId FROM @PlanList) AND StartDate < @Now AND RefContributionTypeId != 1
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
			AND @Now BETWEEN StartDate AND ISNULL(StopDate, @Now) AND RefContributionTypeId = 1
		GROUP BY PolicyBusinessId, RefContributorTypeId)

INSERT INTO @PlanDesc
SELECT                               
	P.PolicyBusinessId as PersonalPensionPlanId,                              
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
	TPI.SRA as RetirementAge,                              	
	-- Calculating TotalRegularPremium depending on FactFind Setting is on  or off
	CASE When @IncludeTopups = 0 Then policymanagement.dbo.FnCustomCalculateContributionsWithTopup(@IndigoClientId, P.PolicyBusinessId,@SelfContributor,@RegularContribution,ISNULL(YC.FrequencyName, EC.FrequencyName),@IsInvestmentPlan, @CurrentUserDate)
	                              else YC.Amount 
								  end AS SelfContributionAmount,
	-- Calculating EmployerContributionAmount depending on FactFind Setting is on  or off
	CASE When @IncludeTopups = 0 Then policymanagement.dbo.FnCustomCalculateContributionsWithTopup(@IndigoClientId, P.PolicyBusinessId,@EmployerContributor,@RegularContribution,ISNULL(YC.FrequencyName, EC.FrequencyName),@IsInvestmentPlan, @CurrentUserDate) 
							      else policymanagement.dbo.FnConvertFrequency(ISNULL(YC.FrequencyName, EC.FrequencyName),EC.FrequencyName,EC.Amount) 
								  end AS EmployerContributionAmount,	
	ISNULL(YC.RefFrequencyId, EC.RefFrequencyId) AS RefContributionFrequencyId,
	-- Calculating TotalTransferContribution depending on FactFind Setting is on  or off
	CASE When @IncludeTopups = 0 Then policymanagement.dbo.FnCustomCalculateContributionsWithTopup(@IndigoClientId, P.PolicyBusinessId,null,@TransferContribution,YC.FrequencyName,@IsInvestmentPlan, @CurrentUserDate) 
	                              else Trans.Amount 
								  end AS TransferContribution,
	-- Calculating LumpsumContributionAmount depending on FactFind Setting is on  or off
    CASE When @IncludeTopups = 0 Then policymanagement.dbo.FnCustomCalculateContributionsWithTopup(@IndigoClientId, P.PolicyBusinessId,null,@LumpSumContribution,YC.FrequencyName,@IsInvestmentPlan, @CurrentUserDate) 
	                              else LumpSum.Amount 
								  end AS LumpSumContribution,
	P.Valuation as Valuation,                              
	P.ValuationDate,   
	B.PensionCommencementLumpSum,
	B.PCLSPaidById,
	B.GADMaximumIncomeLimit,
	B.GuaranteedMinimumIncome,
	B.GADCalculationDate,
	PROT.ReviewDate AS NextReviewDate,
	B.IsCapitalValueProtected,
	B.CapitalValueProtectedAmount,		
	TPI.IsIndexed as Indexed,                     
	TPI.IsCurrent as Preserved,
	B.LumpSumDeathBenefitAmount,
	PROT.InTrust,	
	YC.Amount AS PremiumAmount,
	YC.RefFrequencyId PremiumFrequencyId,
	YC.StartDate AS PremiumStartDate,
	P.ConcurrencyId,
	P.MortgageRepayPercentage,
	P.MortgageRepayAmount,
	P.PlanStatus,
	P.ProductName,
	RPT.IsWrapperFg AS IsWrapperFg,
	B.IsProtectedPCLS,
	TPI.GMPAmount,
	tpi.EnhancedTaxFreeCash,
	tpi.GuaranteedAnnuityRate,
	tpi.ApplicablePenalties,
	tpi.EfiLoyaltyTerminalBonus,
	tpi.GuaranteedGrowthRate,
	tpi.OptionsAvailableAtRetirement,
	tpi.OtherBenefitsAndMaterialFeatures,
	PBE.AdditionalNotes,
	tpi.LifetimeAllowanceUsed,
	tpi.ServiceBenefitSpouseEntitled AS [DeathInServiceSpousalBenefits],
	tpi.DeathBenefit AS [DeathBenefits],
	tpi.IsLifeStylingStrategy,
	tpi.LifeStylingStrategyDetail,
	p.PlanCurrency,
	tpi.TaxedPensionAmount,
	tpi.UntaxedPensionAmount,
	P.SequentialRef,
	P.IsProviderManaged,
	tpi.CrystallisationStatus,
	tpi.HistoricalCrystallisedPercentage,
	tpi.CurrentCrystallisedPercentage,
	tpi.CrystallisedPercentage,
	tpi.UncrystallisedPercentage,
	tpi.PensionArrangement
FROM 
	@PlanDescription P
	JOIN FactFind..TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = P.RefPlanType2ProdSubTypeId
	LEFT JOIN PolicyManagement..TPensionInfo TPI WITH(NOLOCK) ON TPI.PolicyBusinessId = P.PolicyBusinessId                              
	LEFT JOIN PolicyManagement..TPolicyBusinessExt PBE WITH(NOLOCK) ON PBE.PolicyBusinessId = P.PolicyBusinessId
	LEFT JOIN PolicyManagement..TProtection PROT ON PROT.PolicyBusinessId = P.PolicyBusinessId
	LEFT JOIN PolicyManagement..TAssuredLife AL ON AL.ProtectionId = PROT.ProtectionId AND AL.PartyId = @CRMContactId
	LEFT JOIN PolicyManagement..TBenefit B ON P.PolicyBusinessId = B.PolicyBusinessId
	-- Regular Contributions                              
	LEFT JOIN @Contributions EC ON EC.PolicyBusinessId = P.PolicyBusinessId AND EC.TypeId = 1 AND EC.ContributorTypeId = 2
	LEFT JOIN @Contributions YC ON YC.PolicyBusinessId = P.PolicyBusinessId AND YC.TypeId = 1 AND YC.ContributorTypeId = 1
	-- Lump Sum Contributions
	LEFT JOIN (SELECT PolicyBusinessId, SUM(Amount) AS Amount FROM @Contributions WHERE TypeId = 2 GROUP BY PolicyBusinessId) AS LumpSum ON LumpSum.PolicyBusinessId = P.PolicyBusinessId
	LEFT JOIN (SELECT PolicyBusinessId, SUM(Amount) AS Amount FROM @Contributions WHERE TypeId = 3 GROUP BY PolicyBusinessId) AS Trans ON Trans.PolicyBusinessId = P.PolicyBusinessId

	LEFT JOIN policymanagement..TRefPlanType2ProdSubType PTPS ON P.RefPlanType2ProdSubTypeId = PTPS.RefPlanType2ProdSubTypeId 
 	LEFT JOIN policymanagement..TRefPlanType RPT ON RPT.RefPlanTypeId = PTPS.RefPlanTypeId
WHERE 
	PTS.Section = 'Pension Plans';

-- Remove duplicates based on PolicyBusinessId
WITH PBDuplicates AS (
	SELECT *, ROW_NUMBER() OVER (PARTITION BY PolicyBusinessId ORDER BY PolicyBusinessId) AS RowNum
	FROM @PlanDesc
)
DELETE FROM PBDuplicates
WHERE RowNum > 1;

---holding table to identify plans where IsWrapperFg = 0/1 and WrapPlan = 0/x - where 'x' is the wrapl its linked to 
DECLARE @PlanGrouping TABLE (PolicyBusinessId int, IsWrapperPlan bit, WrapPlan int, TopupMasterPolicyBusinessId int Default(0))

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
INSERT INTO @PlanGrouping (PolicyBusinessId, IsWrapperPlan, WrapPlan)
SELECT 
	PD.PolicyBusinessId, IsWrapperPlan = 0, WrapPlan = ISNULL(Wrapper1.ParentPolicyBusinessId, 0) 
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
		WHERE 
			PRPT.PlanTypeName = 'Wrap') AS ParentPlan
			ON ParentPlan.PolicyBusinessId = wrapper1.ParentPolicyBusinessId

WHERE 
	Wrapper1.ParentPolicyBusinessId IS NOT NULL 
	AND ParentPlan.PlanTypeName = 'Wrap'
	AND (TS.IntelligentOfficeStatusType = 'In force' OR TS.IntelligentOfficeStatusType = 'Paid Up') 
	AND TSH.CurrentStatusFG = 1


--Identify TopUp plans
Update a
Set a.TopupMasterPolicyBusinessId = pb.TopupMasterPolicyBusinessId
From @PlanGrouping a 
inner join policymanagement..TPolicyBusiness pb on pb.PolicyBusinessId = a.PolicyBusinessId

--Group Topup plans under their respective 'WRAP' plan types
Update a
Set a.WrapPlan = wp2topupplan.wrapplan
From  @PlanGrouping a
Inner Join (
	--Identify wrap plan linked to a topup master plan
	Select topupplans.TopupMasterPolicyBusinessId, topupplans.PolicyBusinessId, a.WrapPlan
	From @PlanGrouping a
	Inner Join (
		--Identify topup plans 
		Select PolicyBusinessId, TopupMasterPolicyBusinessId
		From @PlanGrouping
		Where WrapPlan = 0 and TopupMasterPolicyBusinessId is not null
		) topupplans on a.PolicyBusinessId = topupplans.TopupMasterPolicyBusinessId
	) wp2topupplan on wp2topupplan.PolicyBusinessId = a.PolicyBusinessId



-- Personal Pension Plans
IF (ISNULL(@ParentPolicyBusinessId ,0) <= 0)
BEGIN
	SELECT                               
		PD.PersonalPensionPlanId,
		PD.PolicyBusinessId,                        
		PD.PolicyDetailId,                        
		PD.CRMContactId,                       
		PD.CRMContactId2,                              
		PD.[Owner],                        
		PD.SellingAdviserId,                        
		PD.SellingAdviserName,                        
		PD.RefPlanTypeId,
		PD.PlanType,
		PD.RefProdProviderId,                        
		PD.Provider,
		PD.PolicyNumber,
		PD.AgencyStatus,
		PD.PolicyStartDate,
		PD.RetirementAge,                              	
		PD.SelfContributionAmount,
		PD.EmployerContributionAmount,
		PD.RefContributionFrequencyId,	
		PD.TransferContribution,
		PD.LumpSumContribution,
		PD.Valuation,                              
		PD.ValuationDate,   
		PD.PensionCommencementLumpSum,
		PD.PCLSPaidById,
		PD.GADMaximumIncomeLimit,
		PD.GuaranteedMinimumIncome,
		PD.GADCalculationDate,
		PD.NextReviewDate,
		PD.IsCapitalValueProtected,
		PD.CapitalValueProtectedAmount,		
		PD.Indexed,                     
		PD.Preserved,
		PD.LumpSumDeathBenefitAmount,
		PD.InTrust,	
		PD.PremiumAmount,
		PD.PremiumFrequencyId,
		PD.PremiumStartDate,
		PD.ConcurrencyId,
		PD.MortgageRepayPercentage,
		PD.MortgageRepayAmount,
		PD.PlanStatus,
		PG.IsWrapperPlan,
		PD.ProductName,
		PG.WrapPlan,
		PD.IsProtectedPCLS,
		PD.GMPAmount,
		PD.EnhancedTaxFreeCash,
		PD.GuaranteedAnnuityRate,
		PD.ApplicablePenalties,
		PD.EfiLoyaltyTerminalBonus,
		PD.GuaranteedGrowthRate,
		PD.OptionsAvailableAtRetirement,
		PD.OtherBenefitsAndMaterialFeatures,
		PD.AdditionalNotes,
		PD.LifetimeAllowanceUsed,
		PD.[DeathInServiceSpousalBenefits],
		PD.[DeathBenefits],
		PD.[IsLifeStylingStrategy],
		PD.[LifeStylingStrategyDetail],
		PD.PlanCurrency,
		PD.TaxedPensionAmount,
		PD.UntaxedPensionAmount,
		PD.SequentialRef,
		PD.IsProviderManaged,
		PD.CrystallisationStatus,
		PD.HistoricalCrystallisedPercentage,
		PD.CurrentCrystallisedPercentage,
		PD.CrystallisedPercentage,
		PD.UncrystallisedPercentage,
		PD.PensionArrangement
	FROM 
		@PlanDesc PD
		LEFT JOIN @PlanGrouping PG ON PD.PolicyBusinessId = PG.PolicyBusinessId
END
ELSE
BEGIN
	SELECT
		P.PolicyBusinessId as PersonalPensionPlanId,                              
		P.PolicyBusinessId,                        
		P.PolicyDetailId,                        
		P.CRMContactId,                       
		P.CRMContactId2,                              
		P.[Owner],                        
		P.SellingAdviserId,                        
		P.SellingAdviserName,                        
		P.RefPlanType2ProdSubTypeId AS RefPlanTypeId,                        
		P.PlanType AS PlanType,
		P.RefProdProviderId,                        
		P.Provider AS Provider,
		P.PolicyNumber,
		P.AgencyStatus,
		P.StartDate AS PolicyStartDate,
		TPI.SRA as RetirementAge,                              	
		YC.Amount AS SelfContributionAmount,
		policymanagement.dbo.FnConvertFrequency(YC.FrequencyName,EC.FrequencyName,EC.Amount) AS EmployerContributionAmount,
		ISNULL(YC.RefFrequencyId, EC.RefFrequencyId) AS RefContributionFrequencyId,
		Trans.Amount AS TransferContribution,
		LumpSum.Amount AS LumpSumContribution,
		P.Valuation as Valuation,                              
		P.ValuationDate,   
		B.PensionCommencementLumpSum,
		B.PCLSPaidById,
		B.GADMaximumIncomeLimit,
		B.GuaranteedMinimumIncome,
		B.GADCalculationDate,
		PROT.ReviewDate AS NextReviewDate,
		B.IsCapitalValueProtected,
		B.CapitalValueProtectedAmount,		
		TPI.IsIndexed as Indexed,                     
		TPI.IsCurrent as Preserved,
		B.LumpSumDeathBenefitAmount,
		PROT.InTrust,	
		YC.Amount AS PremiumAmount,
		YC.RefFrequencyId PremiumFrequencyId,
		YC.StartDate AS PremiumStartDate,
		P.ConcurrencyId,
		P.MortgageRepayPercentage,
		P.MortgageRepayAmount,
		P.PlanStatus,
		CAST(0 AS BIT) AS IsWrapperPlan,
		P.ProductName,
		0 AS [WrapPlan],
		B.IsProtectedPCLS,
		TPI.GMPAmount,
		TPI.EnhancedTaxFreeCash,
		TPI.GuaranteedAnnuityRate,
		TPI.ApplicablePenalties,
		TPI.EfiLoyaltyTerminalBonus,
		TPI.GuaranteedGrowthRate,
		TPI.OptionsAvailableAtRetirement,
		TPI.OtherBenefitsAndMaterialFeatures,
		PBE.AdditionalNotes,
		TPI.LifetimeAllowanceUsed,
		TPI.ServiceBenefitSpouseEntitled AS [DeathInServiceSpousalBenefits],
		TPI.DeathBenefit AS [DeathBenefits],
		TPI.[IsLifeStylingStrategy],
		TPI.[LifeStylingStrategyDetail],
		P.PlanCurrency,
		TPI.TaxedPensionAmount,
		TPI.UntaxedPensionAmount,
		P.SequentialRef,
		P.IsProviderManaged,
		TPI.CrystallisationStatus,
		TPI.HistoricalCrystallisedPercentage,
		TPI.CurrentCrystallisedPercentage,
		TPI.CrystallisedPercentage,
		TPI.UncrystallisedPercentage,
		TPI.PensionArrangement
	FROM 
		@PlanDescription P
		LEFT JOIN PolicyManagement..TPensionInfo TPI WITH(NOLOCK) ON TPI.PolicyBusinessId = P.PolicyBusinessId                              
		LEFT JOIN PolicyManagement..TPolicyBusinessExt PBE WITH(NOLOCK) ON PBE.PolicyBusinessId = P.PolicyBusinessId
		LEFT JOIN PolicyManagement..TProtection PROT ON PROT.PolicyBusinessId = P.PolicyBusinessId
		LEFT JOIN PolicyManagement..TAssuredLife AL ON AL.ProtectionId = PROT.ProtectionId AND AL.PartyId = @CRMContactId
		LEFT JOIN PolicyManagement..TBenefit B ON B.BenefitId = AL.BenefitId
		-- Regular Contributions                              
		LEFT JOIN @Contributions EC ON EC.PolicyBusinessId = P.PolicyBusinessId AND EC.TypeId = 1 AND EC.ContributorTypeId = 2
		LEFT JOIN @Contributions YC ON YC.PolicyBusinessId = P.PolicyBusinessId AND YC.TypeId = 1 AND YC.ContributorTypeId = 1
		-- Lump Sum Contributions
		LEFT JOIN (SELECT PolicyBusinessId, SUM(Amount) AS Amount FROM @Contributions WHERE TypeId = 2 GROUP BY PolicyBusinessId) AS LumpSum ON LumpSum.PolicyBusinessId = P.PolicyBusinessId
		LEFT JOIN (SELECT PolicyBusinessId, SUM(Amount) AS Amount FROM @Contributions WHERE TypeId = 3 GROUP BY PolicyBusinessId) AS Trans ON Trans.PolicyBusinessId = P.PolicyBusinessId
	 JOIN Policymanagement..TWrapperPolicyBusiness wrapper WITH(NOLOCK) ON wrapper.PolicyBusinessId = P.PolicyBusinessId                             
	WHERE   
	 wrapper.ParentPolicyBusinessId = @ParentPolicyBusinessId
END	
SET NOCOUNT OFF
END
GO
