SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrievePersonalMoneyPurchasePensionPlans] 
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
 @NewId bigint, @IncludeTopups bit, @TenantId bigint,  
 @AdviserUserId bigint, @AdviserGroupId bigint, @IncomeReplacementRate smallint, @UserIncomeReplacementRate smallint, @PolicyBusinessId Bigint, @IsInvestmentPlan bigint = 0, @RegularContribution varchar(50) = 'Regular',
 @LumpSumContribution varchar(50) = 'Lump Sum', @SelfContributor varchar(50) = 'Self', @EmployerContributor varchar(50) = 'Employer'
  
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

DECLARE @PlanResult TABLE
(
 MoneyPurchasePensionPlansId bigint not null,  
 PolicyBusinessId bigint null,                              
 PolicyDetailId bigint not null,                                
 CRMContactId bigint not null,                                
 CRMContactId2 bigint null,                                
 [Owner] varchar(16) not null, 
 SellingAdviserId bigint, 
 SellingAdviserName varchar(255),                                                                                              
 PlanType varchar(128) not null,   
 RefProdProviderId bigint not null,
 Provider varchar(128) not null,                                
 PolicyNumber varchar(64) null,
 AgencyStatus varchar(50) null,
 Employer varchar(255) null,  
 DateJoined datetime null,                              
 NormalSchemeRetirementAge int null,
 SelfContributionAmount money null,
 EmployerContributionAmount money null,
 Frequency varchar(32) null,  
 Value money null,            
 ValuationDate datetime,   
 Indexed bit null,
 Preserved bit null,
 ConcurrencyId bigint null,                        
 PlanStatus varchar(50) null,        
 MortgageRepayPercentage money null,   
 MortgageRepayAmount money null,  
 PlanTypeId bigint not NULL,   
 RegularContribution money null,
 TotalSingleContribution money null,                                
 LumpsumContributionAmount money null,                                
 RegularContributionsFrequency varchar(32) null,
 IsWrapperPlan bit null,
 ProductName varchar(255) null,                                
 IsWrapperFg bit,
 WrapperPolicyBusinessId bigint null,
 WrapperParentPolicyBusinessId bigint null,
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
 [EmployerContributionDetail] [varchar] (4000),
 [IsLifeStylingStrategy] BIT NULL,
 [LifeStylingStrategyDetail] [varchar] (4000),
 [PlanCurrency] varchar(3) null,
 [SequentialRef] varchar(50) null,
 [IsProviderManaged] bit null
)

INSERT INTO @PlanResult
(MoneyPurchasePensionPlansId,PolicyBusinessId,PolicyDetailId,CRMContactId,                                
 CRMContactId2,[Owner],SellingAdviserId,SellingAdviserName,PlanType,RefProdProviderId,Provider,                                
 PolicyNumber, AgencyStatus, Employer ,DateJoined,NormalSchemeRetirementAge,SelfContributionAmount,
 EmployerContributionAmount,Frequency,Value,ValuationDate,Indexed,Preserved,ConcurrencyId ,                        
 PlanStatus ,MortgageRepayPercentage ,MortgageRepayAmount ,  
 PlanTypeId  ,RegularContribution  ,TotalSingleContribution  ,                                
 LumpsumContributionAmount  ,RegularContributionsFrequency ,IsWrapperPlan,ProductName ,                                
 IsWrapperFg,WrapperPolicyBusinessId,WrapperParentPolicyBusinessId,GMPAmount,
 EnhancedTaxFreeCash, GuaranteedAnnuityRate, ApplicablePenalties, EfiLoyaltyTerminalBonus, 
 GuaranteedGrowthRate, OptionsAvailableAtRetirement, OtherBenefitsAndMaterialFeatures, AdditionalNotes, LifetimeAllowanceUsed, [DeathInServiceSpousalBenefits], [DeathBenefits], [EmployerContributionDetail], [IsLifeStylingStrategy], [LifeStylingStrategyDetail], [PlanCurrency],[SequentialRef], [IsProviderManaged])
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
 pd.RefProdProviderId,
 pd.Provider,                          
 pd.PolicyNumber,
 pd.AgencyStatus,
 ext.Employer,      
 pd.StartDate as DateJoined,                                
 tpi.SRA as NormalSchemeRetirementAge,                                
 isnull(cont.SelfContributionAmount,0) AS SelfContributionAmount,
 -- Calculating EmployerContributionAmount depending on FactFind Setting is on  or off
 CASE When @IncludeTopups = 0 Then policymanagement.dbo.FnCustomCalculateContributionsWithTopup(@IndigoClientId, pd.PolicyBusinessId,@EmployerContributor,@RegularContribution,cont.SelfFrequency,@IsInvestmentPlan, @CurrentUserDate)
							  else policymanagement.dbo.FnConvertFrequency(cont.SelfFrequency,cont.EmployerFrequency,cont.EmployerContributionAmount) 
							  end AS EmployerContributionAmount,                             
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
 -- Calculating RegularContribution depending on FactFind Setting is on  or off
 CASE When @IncludeTopups = 0 Then policymanagement.dbo.FnCustomCalculateContributionsWithTopup(@IndigoClientId, pd.PolicyBusinessId,@SelfContributor,@RegularContribution,cont.SelfFrequency,@IsInvestmentPlan, @CurrentUserDate)
                                else Pd.ActualRegularPremium 
							    end AS RegularContribution,
 Pd.TotalLumpSum AS TotalSingleContribution,
  -- Calculating LumpsumContributionAmount depending on FactFind Setting is on  or off
 CASE When @IncludeTopups = 0 Then policymanagement.dbo.FnCustomCalculateContributionsWithTopup(@IndigoClientId, pd.PolicyBusinessId,null,@LumpSumContribution,cont.SelfFrequency,@IsInvestmentPlan, @CurrentUserDate) 
                                else LumpSum.Amount 
							    end AS LumpsumContributionAmount,
 --Need to display only regular frequency types
  CASE 
	WHEN Pd.Frequency = 'SINGLE' THEN ''
	ELSE
	CASE 
		WHEN Pd.Frequency = '' AND @IncludeTopups = 0 THEN 'Monthly'
		ELSE pd.Frequency
	END
  END AS RegularContributionsFrequency,
  CAST(1 AS BIT) AS IsWrapperPlan,
  Pd.ProductName,
  RPT.IsWrapperFg,
  wrapper1.PolicyBusinessId,
  wrapper1.ParentPolicyBusinessId,
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
 tpi.ServiceBenefitSpouseEntitled,
 tpi.DeathBenefit as DeathBenefits,
 tpi.EmployerContributionDetail,
 tpi.IsLifeStylingStrategy,
 tpi.LifeStylingStrategyDetail,
 pd.PlanCurrency,
 pd.SequentialRef,
 pd.IsProviderManaged
FROM   
 @PlanDescription pd                
 JOIN TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = Pd.RefPlanType2ProdSubTypeId  
 JOIN policymanagement..TRefPlanType2ProdSubType PTPS ON pd.RefPlanType2ProdSubTypeId = PTPS.RefPlanType2ProdSubTypeId 
 JOIN policymanagement..TRefPlanType RPT ON RPT.RefPlanTypeId = PTPS.RefPlanTypeId   
 LEFT JOIN PolicyManagement..TPensionInfo tpi WITH(NOLOCK) ON tpi.PolicyBusinessId = pd.PolicyBusinessId                                
 LEFT JOIN TMoneyPurchasePensionPlanFFExt ext WITH(NOLOCK) ON ext.PolicyBusinessId = pd.PolicyBusinessId
 LEFT JOIN PolicyManagement..TPolicyBusinessExt PBE WITH(NOLOCK) ON PBE.PolicyBusinessId = pd.PolicyBusinessId
 -- Lump Sum Contributions
 LEFT JOIN (SELECT PolicyBusinessId, SUM(Amount) AS Amount FROM @Contributions WHERE TypeId = 2 GROUP BY PolicyBusinessId) AS LumpSum ON LumpSum.PolicyBusinessId = pd.PolicyBusinessId
  LEFT JOIN (                                
  SELECT   
   pmi.PolicyBusinessId, pmiSelf.Amount as SelfContributionAmount, pmiEmp.Amount as EmployerContributionAmount,   
   pmiSelfLump.Amount as SelfLumpContributionAmount, pmiEmpLump.Amount as EmployerLumpContributionAmount,  
   pmiEmpFreq.FrequencyName AS EmployerFrequency,
   pmiSelfFreq.FrequencyName AS SelfFrequency                              
  FROM   
   @PlanDescription pd        
   JOIN PolicyManagement..TPolicyMoneyIn pmi WITH(NOLOCK) ON pd.PolicyBusinessId =pmi.PolicyBusinessId                           
   LEFT JOIN PolicyManagement..TPolicyMoneyIn pmiSelf WITH(NOLOCK) ON pmiSelf.PolicyBusinessId = pmi.PolicyBusinessId AND pmiSelf.RefContributorTypeId = 1                     
    AND pmiSelf.RefContributionTypeId = 1 AND (pmiSelf.StartDate <= @CurrentUserDate and (pmiSelf.StopDate is null or pmiSelf.StopDate > @CurrentUserDate))                          
   LEFT JOIN PolicyManagement..TPolicyMoneyIn pmiEmp WITH(NOLOCK) ON pmiEmp.PolicyBusinessId = pmi.PolicyBusinessId AND pmiEmp.RefContributorTypeId = 2                     
    AND pmiEmp.RefContributionTypeId = 1 AND (pmiEmp.StartDate <= @CurrentUserDate and (pmiEmp.StopDate is null or pmiEmp.StopDate > @CurrentUserDate))                          
   LEFT JOIN PolicyManagement..TRefFrequency pmiEmpFreq ON pmiEmpFreq.RefFrequencyId = pmiEmp.RefFrequencyId
   LEFT JOIN PolicyManagement..TRefFrequency pmiSelfFreq ON pmiSelfFreq.RefFrequencyId = pmiSelf.RefFrequencyId
   -- sum the self lump sums                          
   LEFT JOIN (                          
    SELECT pmi.PolicyBusinessId, sum(pmi.Amount) as Amount                            
    FROM   
     @PlanDescription pd        
     JOIN PolicyManagement..TPolicyMoneyIn pmi WITH (NOLOCK) ON pd.PolicyBusinessId=pmi.PolicyBusinessId                           
    WHERE   
     pmi.RefContributorTypeId = 1                             
     AND pmi.RefContributionTypeId = 2                             
     AND pmi.StartDate <= @CurrentUserDate                            
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
     AND pmi.StartDate <= @CurrentUserDate                            
    GROUP BY   
     pmi.PolicyBusinessId) pmiEmpLump ON pmiEmpLump.PolicyBusinessId = pmi.PolicyBusinessId                                               
  GROUP BY   
   pmi.PolicyBusinessId, pmiSelf.Amount, pmiEmp.Amount, pmiSelfLump.amount, pmiEmpLump.Amount, pmiEmpFreq.FrequencyName,pmiSelfFreq.FrequencyName                                                      
 ) AS cont ON cont.PolicyBusinessId = pd.PolicyBusinessId                                
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper1 WITH(NOLOCK) ON wrapper1.PolicyBusinessId = Pd.PolicyBusinessId    
 WHERE PTS.Section = 'Money Purchase Pension Schemes'


IF (ISNULL(@ParentPolicyBusinessId ,0) <= 0)
BEGIN
SELECT  DISTINCT                                                      
 PR.MoneyPurchasePensionPlansId,                                
 PR.PolicyBusinessId,                          
 PR.PolicyDetailId,                          
 PR.CRMContactId,                         
 PR.CRMContactId2,                                
 PR.[Owner],                          
 PR.SellingAdviserId,                          
 PR.SellingAdviserName,                          
 PR.PlanType,
 PR.RefProdProviderId,
 PR.Provider,                          
 PR.PolicyNumber,
 PR.AgencyStatus,
 PR.Employer,      
 PR.DateJoined,                                
 PR.NormalSchemeRetirementAge,                                
 PR.SelfContributionAmount,
 PR.EmployerContributionAmount,                             
 Pr.Frequency,                          
 PR.Value,                                
 PR.ValuationDate,     
 PR.Indexed,                       
 PR.Preserved,  
 PR.ConcurrencyId,  
 PR.PlanStatus,  
 PR.MortgageRepayPercentage,  
 PR.MortgageRepayAmount,
 PR.PlanTypeId,
 Pr.RegularContribution,
 PR.TotalSingleContribution,
 Pr.LumpsumContributionAmount,
 Pr.RegularContributionsFrequency,
 Pr.IsWrapperPlan,
 PR.ProductName,
 0 AS [WrapPlan],
 PR.GMPAmount,
 PR.EnhancedTaxFreeCash,
 PR.GuaranteedAnnuityRate,
 PR.ApplicablePenalties,
 PR.EfiLoyaltyTerminalBonus,
 PR.GuaranteedGrowthRate,
 PR.OptionsAvailableAtRetirement,
 PR.OtherBenefitsAndMaterialFeatures,
 PR.AdditionalNotes,
 PR.LifetimeAllowanceUsed,
 PR.[DeathInServiceSpousalBenefits],
 PR.DeathBenefits,
 PR.EmployerContributionDetail,
 PR.IsLifeStylingStrategy,
 PR.LifeStylingStrategyDetail,
 PR.PlanCurrency,
 PR.SequentialRef,
 PR.IsProviderManaged
FROM @PlanResult PR
 WHERE PR.IsWrapperFg = 1 AND PR.WrapperPolicyBusinessId IS NULL
UNION
SELECT                                 
 PR.MoneyPurchasePensionPlansId,                                
 pr.PolicyBusinessId,                          
 PR.PolicyDetailId,                          
 pr.CRMContactId,                         
 pr.CRMContactId2,                                
 pr.[Owner],                          
 pr.SellingAdviserId,                          
 pr.SellingAdviserName,                          
 pr.PlanType,
 pr.RefProdProviderId, 
 pr.Provider,                          
 pr.PolicyNumber,
 pr.AgencyStatus,
 pr.Employer,      
 pr.DateJoined,                                
 pr.NormalSchemeRetirementAge,                               
 pr.SelfContributionAmount, 
 pr.EmployerContributionAmount,                                 
 pr.Frequency,                          
 pr.Value,                                
 pr.ValuationDate,     
 pr.Indexed,                       
 pr.Preserved,  
 pr.ConcurrencyId,  
 pr.PlanStatus,  
 pr.MortgageRepayPercentage,  
 pr.MortgageRepayAmount,
 pr.PlanTypeId,
 pr.RegularContribution,
 Pr.TotalSingleContribution,
 pr.LumpsumContributionAmount,
 pr.RegularContributionsFrequency,
 CAST(0 AS BIT) AS IsWrapperPlan,
 pr.ProductName,
 0 AS [WrapPlan],
 PR.GMPAmount,
 PR.EnhancedTaxFreeCash,
 PR.GuaranteedAnnuityRate,
 PR.ApplicablePenalties,
 PR.EfiLoyaltyTerminalBonus,
 PR.GuaranteedGrowthRate,
 PR.OptionsAvailableAtRetirement,
 PR.OtherBenefitsAndMaterialFeatures,
 PR.AdditionalNotes,
 PR.LifetimeAllowanceUsed,
 PR.[DeathInServiceSpousalBenefits],
 PR.DeathBenefits,
 PR.EmployerContributionDetail,
 PR.IsLifeStylingStrategy,
 PR.LifeStylingStrategyDetail,
 pr.PlanCurrency,
 pr.SequentialRef,
 pr.IsProviderManaged
  FROM   
   @PlanResult pr        
	 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper2 WITH(NOLOCK) ON wrapper2.ParentPolicyBusinessId = pr.PolicyBusinessId                                
	 LEFT JOIN policymanagement..TRefPlanType2ProdSubType PTPS ON pr.PlanTypeId = PTPS.RefPlanType2ProdSubTypeId 
	 LEFT JOIN policymanagement..TRefPlanType RPT ON RPT.RefPlanTypeId = PTPS.RefPlanTypeId 
	 LEFT JOIN policymanagement..TStatusHistory TSH ON TSH.PolicyBusinessId = pr.WrapperParentPolicyBusinessId
	 LEFT JOIN policymanagement..TStatus TS ON TS.StatusId = TSH.StatusId 
WHERE   
 (pr.WrapperPolicyBusinessId IS NULL OR TS.IntelligentOfficeStatusType = 'Deleted') AND wrapper2.ParentPolicyBusinessId IS NULL
 AND RPT.IsWrapperFg = 0
 UNION
 SELECT                                 
 Pr.MoneyPurchasePensionPlansId,                                
 pr.PolicyBusinessId,                          
 pr.PolicyDetailId,                          
 pr.CRMContactId,                         
 pr.CRMContactId2,                                
 pr.[Owner],                          
 pr.SellingAdviserId,                          
 pr.SellingAdviserName,                          
 pr.PlanType,
 pr.RefProdProviderId,
 pr.Provider,                          
 pr.PolicyNumber,
 pr.AgencyStatus,
 pr.Employer,      
 pr.DateJoined,                                
 pr.NormalSchemeRetirementAge,                               
 Pr.SelfContributionAmount, 
 Pr.EmployerContributionAmount,                                 
 Pr.Frequency,                          
 Pr.Value,                                
 pr.ValuationDate,     
 Pr.Indexed,                       
 Pr.Preserved,  
 pr.ConcurrencyId,  
 pr.PlanStatus,  
 pr.MortgageRepayPercentage,  
 pr.MortgageRepayAmount,
 pr.PlanTypeId,
 Pr.RegularContribution,
 Pr.TotalSingleContribution,
 Pr.LumpsumContributionAmount,
 Pr.RegularContributionsFrequency,
 CAST(0 AS BIT) AS IsWrapperPlan,
 Pr.ProductName,
 ISNULL(Pr.WrapperParentPolicyBusinessId, 0) AS [WrapPlan],
 PR.GMPAmount,
 PR.EnhancedTaxFreeCash,
 PR.GuaranteedAnnuityRate,
 PR.ApplicablePenalties,
 PR.EfiLoyaltyTerminalBonus,
 PR.GuaranteedGrowthRate,
 PR.OptionsAvailableAtRetirement,
 PR.OtherBenefitsAndMaterialFeatures,
 PR.AdditionalNotes,
 PR.LifetimeAllowanceUsed,
 PR.[DeathInServiceSpousalBenefits],
 PR.DeathBenefits,
 PR.EmployerContributionDetail,
 PR.IsLifeStylingStrategy,
 PR.LifeStylingStrategyDetail,
 PR.PlanCurrency,
 PR.SequentialRef,
 PR.IsProviderManaged
FROM   
 @PlanResult PR   
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper2 WITH(NOLOCK) ON wrapper2.ParentPolicyBusinessId = Pr.PolicyBusinessId                                
 LEFT JOIN policymanagement..TRefPlanType2ProdSubType PTPS ON pr.PlanTypeId = PTPS.RefPlanType2ProdSubTypeId 
 LEFT JOIN policymanagement..TRefPlanType RPT ON RPT.RefPlanTypeId = PTPS.RefPlanTypeId 
 LEFT JOIN policymanagement..TStatusHistory TSH ON TSH.PolicyBusinessId = pr.WrapperParentPolicyBusinessId
 LEFT JOIN policymanagement..TStatus TS ON TS.StatusId = TSH.StatusId 
 LEFT JOIN (SELECT PRPT.PlanTypeName,PPB.PolicyBusinessId FROM policymanagement..TPolicyBusiness PPB 
    INNER JOIN policymanagement..TPolicyDetail PPD
    ON PPD.PolicyDetailId = PPB.PolicyDetailId
    INNER JOIN policymanagement..TPlanDescription PPDes
    ON PPDes.PlanDescriptionId = PPD.PlanDescriptionId
    INNER JOIN policymanagement..TRefPlanType2ProdSubType PPTPS 
    ON PPDes.RefPlanType2ProdSubTypeId = PPTPS.RefPlanType2ProdSubTypeId   
    INNER JOIN policymanagement..TRefPlanType PRPT 
    ON PRPT.RefPlanTypeId = PPTPS.RefPlanTypeId
    INNER JOIN policymanagement..TRefProdProvider PP
	ON PP.RefProdProviderId = PPDes.RefProdProviderId
	INNER JOIN crm..TCRMContact crm
	ON crm.CRMContactId = PP.CRMContactId 
    WHERE PRPT.PlanTypeName = 'Wrap') AS ParentPlan
    ON ParentPlan.PolicyBusinessId = PR.WrapperParentPolicyBusinessId
WHERE   
 PR.WrapperParentPolicyBusinessId IS NOT NULL AND ParentPlan.PlanTypeName = 'Wrap'
 AND (TS.IntelligentOfficeStatusType = 'In force' OR TS.IntelligentOfficeStatusType = 'Paid Up') AND TSH.CurrentStatusFG = 1
 END
 ELSE
 BEGIN
 SELECT                                 
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
 pd.RefProdProviderId,
 pd.Provider,                          
 pd.PolicyNumber,
 pd.AgencyStatus,
 ext.Employer,      
 pd.StartDate as DateJoined,                                
 tpi.SRA as NormalSchemeRetirementAge,                               
 isnull(cont.SelfContributionAmount,0) AS SelfContributionAmount, 
 policymanagement.dbo.FnConvertFrequency(cont.SelfFrequency,cont.EmployerFrequency,cont.EmployerContributionAmount) AS EmployerContributionAmount,                                  
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
 CAST(0 AS BIT) AS IsWrapperPlan ,
 Pd.ProductName,
 0 AS [WrapPlan],
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
 tpi.EmployerContributionDetail,
 tpi.IsLifeStylingStrategy,
 tpi.LifeStylingStrategyDetail,
 pd.PlanCurrency,
 pd.SequentialRef,
 pd.IsProviderManaged
FROM   
 @PlanDescription pd                
 
 LEFT JOIN PolicyManagement..TPensionInfo tpi WITH(NOLOCK) ON tpi.PolicyBusinessId = pd.PolicyBusinessId                                
 LEFT JOIN TMoneyPurchasePensionPlanFFExt ext WITH(NOLOCK) ON ext.PolicyBusinessId = pd.PolicyBusinessId 
 LEFT JOIN PolicyManagement..TPolicyBusinessExt PBE WITH(NOLOCK) ON PBE.PolicyBusinessId = pd.PolicyBusinessId
  -- Lump Sum Contributions
 LEFT JOIN (SELECT PolicyBusinessId, SUM(Amount) AS Amount FROM @Contributions WHERE TypeId = 2 GROUP BY PolicyBusinessId) AS LumpSum ON LumpSum.PolicyBusinessId = pd.PolicyBusinessId
 LEFT JOIN (                                
  SELECT   
   pmi.PolicyBusinessId, pmiSelf.Amount as SelfContributionAmount, pmiEmp.Amount as EmployerContributionAmount,   
   pmiSelfLump.Amount as SelfLumpContributionAmount, pmiEmpLump.Amount as EmployerLumpContributionAmount,  
   pmiEmpFreq.FrequencyName AS EmployerFrequency,
   pmiSelfFreq.FrequencyName AS SelfFrequency                             
  FROM   
   @PlanDescription pd        
   JOIN PolicyManagement..TPolicyMoneyIn pmi WITH(NOLOCK) ON pd.PolicyBusinessId =pmi.PolicyBusinessId 
   
   LEFT JOIN PolicyManagement..TPolicyMoneyIn pmiSelf WITH(NOLOCK) ON pmiSelf.PolicyBusinessId = pmi.PolicyBusinessId AND pmiSelf.RefContributorTypeId = 1                     
    AND pmiSelf.RefContributionTypeId = 1 AND (pmiSelf.StartDate <= @CurrentUserDate and (pmiSelf.StopDate is null or pmiSelf.StopDate > @CurrentUserDate))                          
   LEFT JOIN PolicyManagement..TPolicyMoneyIn pmiEmp WITH(NOLOCK) ON pmiEmp.PolicyBusinessId = pmi.PolicyBusinessId AND pmiEmp.RefContributorTypeId = 2                     
    AND pmiEmp.RefContributionTypeId = 1 AND (pmiEmp.StartDate <= @CurrentUserDate and (pmiEmp.StopDate is null or pmiEmp.StopDate > @CurrentUserDate))                          
   LEFT JOIN PolicyManagement..TRefFrequency pmiEmpFreq ON pmiEmpFreq.RefFrequencyId = pmiEmp.RefFrequencyId
   LEFT JOIN PolicyManagement..TRefFrequency pmiSelfFreq ON pmiSelfFreq.RefFrequencyId = pmiSelf.RefFrequencyId   
   -- sum the self lump sums                          
   LEFT JOIN (                          
    SELECT pmi.PolicyBusinessId, sum(pmi.Amount) as Amount                            
    FROM   
     @PlanDescription pd        
     JOIN PolicyManagement..TPolicyMoneyIn pmi WITH (NOLOCK) ON pd.PolicyBusinessId=pmi.PolicyBusinessId                           
    WHERE   
     pmi.RefContributorTypeId = 1                             
     AND pmi.RefContributionTypeId = 2                             
     AND pmi.StartDate <= @CurrentUserDate                            
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
     AND pmi.StartDate <= @CurrentUserDate                            
    GROUP BY   
     pmi.PolicyBusinessId) pmiEmpLump ON pmiEmpLump.PolicyBusinessId = pmi.PolicyBusinessId                                               
  GROUP BY   
   pmi.PolicyBusinessId, pmiSelf.Amount, pmiEmp.Amount, pmiSelfLump.amount, pmiEmpLump.Amount, pmiEmpFreq.FrequencyName, pmiSelfFreq.FrequencyName                                                      
 ) AS cont ON cont.PolicyBusinessId = pd.PolicyBusinessId 
 JOIN Policymanagement..TWrapperPolicyBusiness wrapper WITH(NOLOCK) ON wrapper.PolicyBusinessId = PD.PolicyBusinessId                             
WHERE   
  wrapper.ParentPolicyBusinessId = @ParentPolicyBusinessId
 END
SET NOCOUNT OFF
End
GO
