SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrievePersonalOtherInvestmentsSubPlans]   
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
 LowMaturityValue money null,  
 MediumMaturityValue money null,  
 HighMaturityValue money null,
 ProjectionDetails varchar(5000) null,
 InterestRate money null,
 PlanCurrency varchar(3) null,
 SequentialRef varchar(50) null,
 IsProviderManaged bit null
)  
   
 -- Basic Plan Details      
 Insert into @PlanDescription  
 Select * from dbo.FnCustomGetPlanDescriptionForOtherInvestments(@CRMContactId, @CRMContactId2, @TenantId, @ExcludePlanPurposes, @IncludeTopups)   

 


-- Get a list of plan ids for these clients  
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
   
			-- other investments                                  
			SELECT DISTINCT                                   
			 Pd.PolicyBusinessId AS OtherInvestmentsPlansId,                              
			 pd.CRMContactId,                             
			 pd.CRMContactId2,                                  
			 pd.[Owner],                            
			 pd.SellingAdviserId,                            
			 pd.SellingAdviserName,                            
			 pd.Provider,                            
			 pd.PolicyNumber,
			 pd.AgencyStatus,
			 pd.PlanCurrency,                            
			 pd.PlanType,      
			 Pd.RefPlanType2ProdSubTypeId,                        
			 CASE @ExcludePlanPurposes     
			  WHEN 1 THEN ''    
			  ELSE ISNULL(Pd.PlanPurpose,'')    
			 END AS PlanPurposeText,                                    
			 t.ContributionThisTaxYearFg,                                  
			 Pd.RegularPremium as RegularContribution,               
			 
			 CASE                             
			  WHEN isnull(Pd.ActualRegularPremium,0) > 0 then Pd.Frequency    
			  WHEN isnull(Pd.TotalLumpSum,0) > 0 then 'Single'                            
			  else Pd.Frequency    
			 END AS Frequency,                            
			 pd.CurrentValue,                            
			 pd.StartDate as OtherInvStartDate,         
			 pd.MaturityDate,       
			 T.MonthlyIncome,                                  
			 P.InTrust AS InTrustFg,    
			 pd.ExcludeValuation,     
			 pd.ConcurrencyId,    
			 pd.PlanStatus,    
			 pd.MortgageRepayPercentage,    
			 pd.MortgageRepayAmount,    
			 [IsGuaranteedToProtectOriginalInvestment]  ,  
			 pd.MortgageRepayAmount,  
			 CASE @ExcludePlanPurposes     
				WHEN 1 THEN null    
				ELSE pd.PlanPurposeId    
			 END As PlanPurposeId, 
			 pd.LowMaturityValue,  
			 pd.MediumMaturityValue,  
			 pd.HighMaturityValue, pd.ProjectionDetails, 
			 P.ToWhom, 
			 Pd.ActualRegularPremium AS ActualRegularContribution,
			 Pd.TotalLumpSum AS TotalSingleContribution,
			 --Need to display only regular frequency types
			 CASE When UPPER(Pd.Frequency) = 'SINGLE' Then '' else Pd.Frequency End AS RegularContributionsFrequency,
			  CAST(1 AS BIT) AS IsWrapperPlan,
			 Pd.ProductName,
			 LumpSum.Amount as LumpsumContributionAmount,
			 pd.InterestRate,
			 pd.SequentialRef,
			 pd.IsProviderManaged,
			Tp.PensionArrangement,
			Tp.CrystallisationStatus,
			Tp.HistoricalCrystallisedPercentage,
			Tp.CurrentCrystallisedPercentage,
			Tp.CrystallisedPercentage,
			Tp.UncrystallisedPercentage
			FROM     
			 @PlanDescription pd                                  
			 JOIN TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = Pd.RefPlanType2ProdSubTypeId    
			 JOIN policymanagement..TRefPlanType2ProdSubType PTPS ON pd.RefPlanType2ProdSubTypeId = PTPS.RefPlanType2ProdSubTypeId 
			 JOIN policymanagement..TRefPlanType RPT ON RPT.RefPlanTypeId = PTPS.RefPlanTypeId   
			 LEFT JOIN TOtherInvestmentsPlanFFExt t ON t.PolicyBusinessId = pd.PolicyBusinessId                                  
			 LEFT JOIN Policymanagement..TProtection P WITH(NOLOCK) ON P.PolicyBusinessId = pd.PolicyBusinessId    
			 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper WITH(NOLOCK) ON wrapper.PolicyBusinessId = pd.PolicyBusinessId
			 LEFT JOIN PolicyManagement..TPensionInfo Tp WITH(NOLOCK) ON Tp.PolicyBusinessId = Pd.PolicyBusinessId 
			 -- Lump Sum Contributions
			 LEFT JOIN (SELECT PolicyBusinessId, SUM(Amount) AS Amount FROM @Contributions WHERE TypeId = 2 GROUP BY PolicyBusinessId) AS LumpSum ON LumpSum.PolicyBusinessId = pd.PolicyBusinessId
			 WHERE     
			 PTS.Section = 'Other Investments'  
SET NOCOUNT OFF
END
GO