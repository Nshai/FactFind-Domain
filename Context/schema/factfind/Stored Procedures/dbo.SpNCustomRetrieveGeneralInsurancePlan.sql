SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveGeneralInsurancePlan]  
(    
  @IndigoClientId bigint,                                    
  @UserId bigint,                                    
  @FactFindId bigint ,      
  @ExcludePlanPurposes BIT = 0     
)    
As    
Begin    
SET NOCOUNT ON
--SET DATEFORMAT dmy      
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
  
  
   
     
SELECT DISTINCT    
 Pd.PolicyBusinessId as GeneralInsurancePlanId,                                  
 Pd.PolicyBusinessId,                                      
 Pd.CRMContactId,     
 Pd.CRMContactId2,    
 Pd.[Owner],      
 pd.SellingAdviserId,                            
 pd.SellingAdviserName,        
 Pd.RefProdProviderId,
 Pd.Provider AS ProviderName,
 Pd.AgencyStatus,
 Pd.PlanCurrency,
 Pd.RefPlanType2ProdSubTypeId,                                    
 Pd.RegularPremium,                                  
 CASE WHEN Pd.Frequency IS NULL OR Pd.Frequency = '' THEN R.FrequencyName ELSE Pd.Frequency END AS PremiumFrequency,                                                    
 Pd.StartDate,       
 P.RenewalDate,                                  
 B.SumAssured AS BuildingsSumInsured,    
 B.ExcessAmount AS BuildingsExcess,    
 CAST(CASE WHEN B.InsuranceCoverOptions = 0 THEN 0 ELSE  1 END AS BIT) AS BuildingsAccidentalDamage,  
 --B.InsuranceCoverOptions&1 AS BuildingsAccidentalDamage,    
 C.SumAssured AS ContentsSumInsured,    
 C.ExcessAmount AS ContentsExcess,    
 CAST(CASE WHEN B.InsuranceCoverOptions = 0 THEN 0 ELSE  1 END AS BIT) AS ContentsAccidentalDamage,  
 --C.InsuranceCoverOptions&1 AS ContentsAccidentalDamage,     
 P.PremiumLoading,    
 P.Exclusions,    
 1 AS ConcurrencyId, -- Not currently used.    
 P.PropertyInsuranceType,  
 Pd.ProductName,
 Pd.PlanType As PlanTypeText,
 CASE WHEN wrapper1.PolicyBusinessId IS NULL AND wrapper2.ParentPolicyBusinessId IS NULL
 THEN CONVERT(BIT,0)
 ELSE CONVERT(BIT,1) END AS IsWrapper,
 Pd.SequentialRef,
 Pd.IsProviderManaged,
 TPI.PensionArrangement,
 TPI.CrystallisationStatus,
 TPI.HistoricalCrystallisedPercentage,
 TPI.CurrentCrystallisedPercentage,
 TPI.CrystallisedPercentage,
 TPI.UncrystallisedPercentage
FROM
 @PlanDescription Pd     
 JOIN TRefPlanTypeToSection PTS WITH(NOLOCK) ON PTS.RefPlanType2ProdSubTypeId = Pd.RefPlanType2ProdSubTypeId    
 LEFT JOIN PolicyManagement..TProtection P WITH(NOLOCK) ON P.PolicyBusinessId = Pd.PolicyBusinessId                                  
 -- Buildings    
 LEFT JOIN PolicyManagement..TGeneralInsuranceDetail B WITH(NOLOCK) ON B.ProtectionId = P.ProtectionId AND B.RefInsuranceCoverCategoryId = 1    
 -- Contents    
 LEFT JOIN PolicyManagement..TGeneralInsuranceDetail C WITH(NOLOCK) ON C.ProtectionId = P.ProtectionId AND C.RefInsuranceCoverCategoryId = 2    
 LEFT JOIN PolicyManagement..TPolicyMoneyIn M ON M.PolicyBusinessId = Pd.PolicyBusinessId  
 LEFT JOIN PolicyManagement..TRefFrequency R ON M.RefFrequencyId = R.RefFrequencyId 
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper1 WITH(NOLOCK) ON wrapper1.PolicyBusinessId = Pd.PolicyBusinessId  
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper2 WITH(NOLOCK) ON wrapper2.ParentPolicyBusinessId = Pd.PolicyBusinessId 
 LEFT JOIN PolicyManagement..TPensionInfo TPI ON TPI.PolicyBusinessId = Pd.PolicyBusinessId
WHERE     
 PTS.Section = 'Building and Contents Insurance' 

SET NOCOUNT OFF
End    
GO