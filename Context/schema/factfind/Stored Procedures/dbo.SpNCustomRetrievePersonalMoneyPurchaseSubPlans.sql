SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrievePersonalMoneyPurchaseSubPlans] 
(
  @IndigoClientId bigint,                                
  @UserId bigint,                                
  @FactFindId bigint,  
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
 

 --Start [IO-12445]
DECLARE @PlanList TABLE (BusinessId bigint PRIMARY KEY, DetailId bigint)  

INSERT INTO @PlanList  
SELECT DISTINCT PB.PolicyBusinessId, PB.PolicyDetailId  
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
--End [12445]


SELECT  DISTINCT                                                      
 Pd.PolicyBusinessId as MoneyPurchasePensionPlansId,                                
 --pd.*,                                
 pd.PolicyBusinessId,                          
 pd.PolicyDetailId,                          
 pd.CRMContactId,                         
 pd.CRMContactId2,                                
 pd.[Owner],                          
 pd.SellingAdviserId,                          
 pd.SellingAdviserName,                          
 pd.PlanType,                          
 pd.Provider,                          
 pd.PolicyNumber,
 pd.AgencyStatus,
 pd.PlanCurrency,                    
 ext.Employer,      
 pd.StartDate as DateJoined,                                
 tpi.SRA as NormalSchemeRetirementAge,                               
 isnull(cont.SelfContributionAmount,0) AS SelfContributionAmount, 
 isnull(cont.EmployerContributionAmount,0) AS EmployerContributionAmount,                                
 case                           
  when isnull(cont.SelfContributionAmount,0) > 0 then pd.Frequency                                
  when isnull(cont.SelfLumpContributionAmount,0) > 0 then 'Single'                          
  when isnull(cont.EmployerContributionAmount,0) > 0 then cont.EmployerFrequency                                
  when isnull(cont.EmployerLumpContributionAmount,0) > 0 then cont.EmployerFrequency                      
 end as Frequency,                          
 pd.Valuation as Value,                                
 pd.ValuationDate,     
 tpi.IsIndexed as Indexed,                       
 tpi.IsCurrent as Preserved,  
 pd.ConcurrencyId,  
 pd.PlanStatus,  
 pd.MortgageRepayPercentage,  
 pd.MortgageRepayAmount,
 pd.RefPlanType2ProdSubTypeId As PlanTypeId,
 Pd.ActualRegularPremium AS RegularContribution,
 Pd.TotalLumpSum AS TotalSingleContribution,
 LumpSum.Amount as LumpsumContributionAmount,
  --Need to display only regular frequency types
 CASE When UPPER(Pd.Frequency) = 'SINGLE' Then '' else Pd.Frequency End AS RegularContributionsFrequency, 
  CAST(1 AS BIT) AS IsWrapperPlan,
  Pd.ProductName,
  tpi.GMPAmount,
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
  tpi.DeathBenefit as DeathBenefits,
  pd.IsProviderManaged,
  tpi.PensionArrangement,
  tpi.CrystallisationStatus,
  tpi.HistoricalCrystallisedPercentage,
  tpi.CurrentCrystallisedPercentage,
  tpi.CrystallisedPercentage,
  tpi.UncrystallisedPercentage
FROM   
 @PlanDescription pd                
 JOIN TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = Pd.RefPlanType2ProdSubTypeId  
 JOIN policymanagement..TRefPlanType2ProdSubType PTPS ON pd.RefPlanType2ProdSubTypeId = PTPS.RefPlanType2ProdSubTypeId 
 JOIN policymanagement..TRefPlanType RPT ON RPT.RefPlanTypeId = PTPS.RefPlanTypeId   
 LEFT JOIN PolicyManagement..TPensionInfo tpi WITH(NOLOCK) ON tpi.PolicyBusinessId = pd.PolicyBusinessId                                
 LEFT JOIN policymanagement..TPolicyBusinessExt PBE ON PBE.PolicyBusinessId = pd.PolicyBusinessId
 LEFT JOIN TMoneyPurchasePensionPlanFFExt ext WITH(NOLOCK) ON ext.PolicyBusinessId = pd.PolicyBusinessId
 -- Lump Sum Contributions
 LEFT JOIN (SELECT PolicyBusinessId, SUM(Amount) AS Amount FROM @Contributions WHERE TypeId = 2 GROUP BY PolicyBusinessId) AS LumpSum ON LumpSum.PolicyBusinessId = pd.PolicyBusinessId
  LEFT JOIN (                                
  SELECT   
   pmi.PolicyBusinessId, pmiSelf.Amount as SelfContributionAmount, pmiEmp.Amount as EmployerContributionAmount,   
   pmiSelfLump.Amount as SelfLumpContributionAmount, pmiEmpLump.Amount as EmployerLumpContributionAmount,  
   pmiEmpFreq.FrequencyName AS EmployerFrequency                              
  FROM   
   @PlanDescription pd        
   JOIN PolicyManagement..TPolicyMoneyIn pmi WITH(NOLOCK) ON pd.PolicyBusinessId =pmi.PolicyBusinessId                           
   LEFT JOIN PolicyManagement..TPolicyMoneyIn pmiSelf WITH(NOLOCK) ON pmiSelf.PolicyBusinessId = pmi.PolicyBusinessId AND pmiSelf.RefContributorTypeId = 1                     
    AND pmiSelf.RefContributionTypeId = 1 AND (pmiSelf.StartDate <= getdate() and (pmiSelf.StopDate is null or pmiSelf.StopDate > getdate()))                          
   LEFT JOIN PolicyManagement..TPolicyMoneyIn pmiEmp WITH(NOLOCK) ON pmiEmp.PolicyBusinessId = pmi.PolicyBusinessId AND pmiEmp.RefContributorTypeId = 2                     
    AND pmiEmp.RefContributionTypeId = 1 AND (pmiEmp.StartDate <= getdate() and (pmiEmp.StopDate is null or pmiEmp.StopDate > getdate()))                          
   LEFT JOIN PolicyManagement..TRefFrequency pmiEmpFreq ON pmiEmpFreq.RefFrequencyId = pmiEmp.RefFrequencyId  
   -- sum the self lump sums                          
   LEFT JOIN (                          
    SELECT pmi.PolicyBusinessId, sum(pmi.Amount) as Amount                            
    FROM   
     @PlanDescription pd        
     JOIN PolicyManagement..TPolicyMoneyIn pmi WITH (NOLOCK) ON pd.PolicyBusinessId=pmi.PolicyBusinessId                           
    WHERE   
     pmi.RefContributorTypeId = 1                             
     AND pmi.RefContributionTypeId = 2                             
     AND pmi.StartDate <= getdate()                            
    GROUP BY   
     pmi.PolicyBusinessId) pmiSelfLump ON pmiSelfLump.PolicyBusinessId = pmi.PolicyBusinessId                          
   -- sum the employer lump sums                          
   LEFT JOIN (                          
    SELECT pmi.PolicyBusinessId, sum(pmi.Amount) as Amount                            
    FROM   
     @PlanDescription pd        
     JOIN PolicyManagement..TPolicyMoneyIn pmi WITH (NOLOCK) ON pd.PolicyBusinessId=pmi.PolicyBusinessId                          
    WHERE   
     pmi.RefContributorTypeId = 2                             
     AND pmi.RefContributionTypeId = 2                             
     AND pmi.StartDate <= getdate()                            
    GROUP BY   
     pmi.PolicyBusinessId) pmiEmpLump ON pmiEmpLump.PolicyBusinessId = pmi.PolicyBusinessId                                               
  GROUP BY   
   pmi.PolicyBusinessId, pmiSelf.Amount, pmiEmp.Amount, pmiSelfLump.amount, pmiEmpLump.Amount, pmiEmpFreq.FrequencyName                                                      
 ) AS cont ON cont.PolicyBusinessId = pd.PolicyBusinessId                                
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper1 WITH(NOLOCK) ON wrapper1.PolicyBusinessId = Pd.PolicyBusinessId    
WHERE   
 PTS.Section = 'Money Purchase Pension Schemes' 
 SET NOCOUNT OFF
 END
GO