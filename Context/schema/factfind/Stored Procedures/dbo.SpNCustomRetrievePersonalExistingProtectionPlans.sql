SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
Modification History (most recent first)
Date                   Modifier                    Issue Description
----                   ---------                   --------------------
20250611               spagadala                   IOADV-3136: Held in super contribution to show as premium @ fact find
*/
  
CREATE PROCEDURE [dbo].[SpNCustomRetrievePersonalExistingProtectionPlans]   
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
 @AdviserUserId bigint, @AdviserGroupId bigint, @IncomeReplacementRate smallint, @UserIncomeReplacementRate smallint,
 @RegularTypeId INT = 1,
 @SelfContributorTypeId INT = 1,
 @HISContributorTypeId INT = 9;    
    
---------------------------------------------------------------------------------    
-- Get some initial settings    
---------------------------------------------------------------------------------    
 Exec dbo.SpNCustomRetrievePersonalDataInitialSettings @IndigoClientId, @UserId, @FactFindId, @ExcludePlanPurposes,@CRMContactId OutPut,   
                @CRMContactId2 OutPut, @AdviserId OutPut, @AdviserCRMId OutPut, @AdviserName OutPut,    
                @PreExistingAdviserId OutPut, @PreExistingAdviserName OutPut, @PreExistingAdviserCRMId OutPut,                      
                @NewId OutPut, @IncludeTopups OutPut, @TenantId OutPut,    
                @AdviserUserId OutPut, @AdviserGroupId OutPut, @IncomeReplacementRate OutPut, @UserIncomeReplacementRate OutPut  
   
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
 AND B.CurrentValue != 0 -- Child plan must have a value.    

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
                                         
-- Protection                                
SELECT DISTINCT  
 Pd.PolicyBusinessId as ProtectionPlansId,                                
 Pd.PolicyBusinessId,                                    
 Pd.CRMContactId,   
 Pd.CRMContactId2,  
 Pd.[Owner],    
 pd.SellingAdviserId,                          
 pd.SellingAdviserName,      
 Pd.RefProdProviderId,
 Pd.Provider AS Provider,
 Pd.PolicyNumber,
 Pd.AgencyStatus,
 Pd.PlanCurrency,                           
 Pd.RefPlanType2ProdSubTypeId,
 Pd.PlanType,
 CASE @ExcludePlanPurposes   
  WHEN 1 THEN ''  
  ELSE ISNULL(Pd.PlanPurpose,'')  
 END PlanPurposeText,                                  
 Pd.StartDate as ProtectionStartDate,    
 Pd.MaturityDate,                                
CASE
  WHEN Pd.ParentPolicyBusinessId IS NOT NULL THEN ISNULL(YC.Amount, Pd.TotalLumpSum)
  ELSE Pd.RegularPremium 
  END AS RegularPremium,                         
 CASE
    WHEN Pd.ParentPolicyBusinessId IS NOT NULL THEN YC.FrequencyName
    ELSE ISNULL(Pd.Frequency, YC.FrequencyName)
 END AS PremiumFrequency,                              
 GI.SumAssured,  
 -- Just take majority of benefits from the 1st life (data should be the same for 2nd for the fields that FF cares about)  
 B1.BenefitAmount,                                
 B1.RefFrequencyId AS BenefitFrequencyId,                                 
 P.CriticalIllnessSumAssured as CriticalIllnessAmount,         
 P.LifeCoverSumAssured AS LifeCoverAmount,
 P.PtdCoverAmount AS TpdAssured,                    
 P.LifeCoverPremiumStructure AS AULifeCoverPremiumStructure,
 P.ProtectionPayoutType AS AUProtectionPayoutType,
 P.IncomePremiumStructure AS AUIncomePremiumStructure,
 P.CriticalIllnessPremiumStructure AS AUCriticalIllnessPremiumStructure,
 P.PtdCoverPremiumStructure AS AUPtdCoverPremiumStructure,
 P.SeverityCoverAmount AS AUSeverityCoverAmount,
 P.SeverityCoverPremiumStructure AS AUSeverityCoverPremiumStructure,
 P.ExpensePremiumStructure AS AUExpensePremiumStructure,
 CASE                         
  WHEN ISNULL(Al1.AssuredLifeId,0) > 0 AND ISNULL(Al2.AssuredLifeId,0) > 0 THEN 'Joint'  
  WHEN AL1.PartyId = @CRMContactId2 THEN 'Client 2'  
  ELSE 'Client 1'      
 END AS LifeAssured,                                
 B1.BenefitDeferredPeriod,   
 B1.DeferredPeriodIntervalId,                           
 B1.RefBenefitPeriodId,         
 P.PaymentBasisId AS RefPaymentBasisId,                       
 P.InTrust AS AssignedInTrust,  
 pd.ConcurrencyId,  
 Pd.PlanStatus,
 CASE @ExcludePlanPurposes     
			WHEN 1 THEN null    
			ELSE Pd.PlanPurposeId    
 END As PlanPurposeId,
 P.IsForProtectionShortfallCalculation,
 B1.OtherBenefitPeriodText,
 pd.ProductName,
 CASE WHEN wrapper1.PolicyBusinessId IS NULL AND wrapper2.ParentPolicyBusinessId IS NULL
 THEN CONVERT(BIT,0)
 ELSE CONVERT(BIT,1) END AS IsWrapper,
 TPI.GMPAmount,
 TPI.DeathBenefit as DeathBenefits,
 B1.SplitBenefitAmount,
 B1.RefSplitFrequencyId,
 B1.SplitBenefitDeferredPeriod,
 B1.SplitDeferredPeriodIntervalId,
 Pd.PlanCurrency,
 Pd.SequentialRef,
 Pd.IsProviderManaged,
 Pd.ParentPolicyBusinessId as RelatedToProductId,
 TPI.PensionArrangement,
 TPI.CrystallisationStatus,
 TPI.HistoricalCrystallisedPercentage,
 TPI.CurrentCrystallisedPercentage,
 TPI.CrystallisedPercentage,
 TPI.UncrystallisedPercentage
FROM                                
 @PlanDescription Pd
 JOIN TRefPlanTypeToSection PTS WITH(NOLOCK) ON PTS.RefPlanType2ProdSubTypeId = Pd.RefPlanType2ProdSubTypeId  
 -- Protection details should always be available but...  
 LEFT JOIN PolicyManagement..TProtection P WITH(NOLOCK) ON P.PolicyBusinessId = Pd.PolicyBusinessId                                
 LEFT JOIN PolicyManagement..TGeneralInsuranceDetail GI WITH(NOLOCK) ON GI.ProtectionId = P.ProtectionId AND GI.RefInsuranceCoverCategoryId = 5 -- Payment Protection  
 -- Life assured 1  
 LEFT JOIN PolicyManagement..TAssuredLife AL1 WITH(NOLOCK) ON AL1.ProtectionId = P.ProtectionId AND AL1.OrderKey = 1  
 LEFT JOIN PolicyManagement..TBenefit B1 WITH(NOLOCK) ON B1.BenefitId = AL1.BenefitId  
 -- Life assured 2.  
 LEFT JOIN PolicyManagement..TAssuredLife AL2 WITH(NOLOCK) ON AL2.ProtectionId = P.ProtectionId AND AL2.OrderKey = 2  
 -- Your Contribution                                
 LEFT JOIN @Contributions YC ON YC.PolicyBusinessId = Pd.PolicyBusinessId AND YC.TypeId = @RegularTypeId AND 
 ((Pd.ParentPolicyBusinessId IS NOT NULL AND YC.ContributorTypeId = @HISContributorTypeId)
  OR
  (Pd.ParentPolicyBusinessId IS NULL AND YC.ContributorTypeId = @SelfContributorTypeId))
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper1 WITH(NOLOCK) ON wrapper1.PolicyBusinessId = Pd.PolicyBusinessId  
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper2 WITH(NOLOCK) ON wrapper2.ParentPolicyBusinessId = Pd.PolicyBusinessId
 LEFT JOIN PolicyManagement..TPensionInfo TPI ON TPI.PolicyBusinessId = Pd.PolicyBusinessId
WHERE   
 PTS.Section = 'Protection'
SET NOCOUNT OFF
End  
GO