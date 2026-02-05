SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrievePersonalPensionSubPlans] 
(
  @IndigoClientId bigint,                                
  @UserId bigint,                                
  @FactFindId bigint ,
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
WHERE PolicyBusinessId IN (SELECT BusinessId FROM @PlanList) AND StartDate < @CurrentUserDate AND RefContributionTypeId != 1
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
             

-- Personal Pension Plans
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
	P.RefProdProviderId,                        
	P.PolicyNumber,    
	P.PlanCurrency,                
	P.StartDate AS PolicyStartDate,
	TPI.SRA as RetirementAge,                              	
	YC.Amount AS SelfContributionAmount,
	EC.Amount AS EmployerContributionAmount,
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
	CAST(1 AS BIT) AS IsWrapperPlan,
	P.ProductName,
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
	P.IsProviderManaged,
	TPI.PensionArrangement,
	TPI.CrystallisationStatus,
	TPI.HistoricalCrystallisedPercentage,
	TPI.CurrentCrystallisedPercentage,
	TPI.CrystallisedPercentage,
	TPI.UncrystallisedPercentage
FROM 
	@PlanDescription P
	JOIN FactFind..TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = P.RefPlanType2ProdSubTypeId
	JOIN policymanagement..TRefPlanType2ProdSubType PTPS ON P.RefPlanType2ProdSubTypeId = PTPS.RefPlanType2ProdSubTypeId 
 	JOIN policymanagement..TRefPlanType RPT ON RPT.RefPlanTypeId = PTPS.RefPlanTypeId   
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
	LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper WITH(NOLOCK) ON wrapper.PolicyBusinessId = P.PolicyBusinessId    
WHERE 
	PTS.Section = 'Pension Plans'
SET NOCOUNT OFF
END
GO