SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrievePersonalEquityReleasePlans] 
(
  @IndigoClientId bigint,                                
  @UserId bigint,                                
  @FactFindId bigint ,  
  @ExcludePlanPurposes BIT = 0 
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
 
 -- Mortgages                                
SELECT                                
 Pd.PolicyBusinessId as EquityReleaseId,                                
 Pd.CRMContactId,  
 Pd.CRMContactId2, 
 Pd.[Owner],                               
 pd.SellingAdviserId,                          
 pd.SellingAdviserName,      
 Pd.RefProdProviderId,
 Pd.Provider,    
 Pd.PolicyNumber,
 Pd.AgencyStatus,
 EQ.RefEquityReleaseTypeId,
 EQ.PercentageOwnershipSold,
 EQ.AddressStoreId,
 EQ.RateType,  
 pd.StartDate,
 EQ.RefMortgageRepaymentMethodId AS RepaymentMethod, 
 RP.MortgageRepaymentMethod AS RepaymentMethodString,                              
 EQ.RepaymentAmount,  
 EQ.InterestOnlyAmount,
 EQ.LoanAmount,
 EQ.InterestRatePercentage,  
 EQ.LumpsumAmount,
 EQ.MonthlyIncomeAmount,
 EQ.AssetsId,
 EQ.InterestRate,
 PBA.AttributeValue AS AmountReleased,                       
 EQ.PenaltyFg AS RedemptionFg, 
 EQ.RedemptionTerms,  
 EQ.PenaltyExpiryDate AS RedemptionEndDate,
 pd.ProductName,
 (Select top 1 -PlanValue from policymanagement..TPlanValuation
			where PolicyBusinessId = Pd.PolicyBusinessId
			order by PlanValueDate desc, PlanValuationId desc) as 'CurrentBalance',
 CASE WHEN wrapper1.PolicyBusinessId IS NULL AND wrapper2.ParentPolicyBusinessId IS NULL
 THEN CONVERT(BIT,0)
 ELSE CONVERT(BIT,1) END AS IsWrapper ,
 Pd.PlanCurrency,
 EQ.AddressId,
 assets.Amount as AssetAmount,
 assets.CurrencyCode as CurrencyCode,
 EQ.IsToBeConsolidated as Consolidate,
 EQ.IsLiabilityToBeRepaid as IsToBeRepaid,
 EQ.LiabilityRepaymentDescription as LiabilityRepaymentDescription,
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
 LEFT JOIN PolicyManagement..TEquityRelease EQ WITH(NOLOCK) ON EQ.PolicyBusinessId = Pd.PolicyBusinessId   
 LEFT JOIN PolicyManagement..TPolicyBusinessAttribute PBA WITH(NOLOCK) ON EQ.PolicyBusinessId = PBA.PolicyBusinessId
 LEFT JOIN PolicyManagement..TAttributeList2Attribute ALA ON ALA.AttributeList2AttributeId = PBA.AttributeList2AttributeId
 LEFT JOIN PolicyManagement..TAttributelist AL ON ALA.AttributeListId = AL.AttributeListId AND AL.Name = 'Amount Released'
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper1 WITH(NOLOCK) ON wrapper1.PolicyBusinessId = Pd.PolicyBusinessId  
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper2 WITH(NOLOCK) ON wrapper2.ParentPolicyBusinessId = Pd.PolicyBusinessId
 LEFT JOIN policymanagement..TRefMortgageRepaymentMethod RP WITH(NOLOCK) ON RP.RefMortgageRepaymentMethodId = EQ.RefMortgageRepaymentMethodId	
 LEFT JOIN factfind..TAssets assets WITH(NOLOCK) ON EQ.AssetsId = assets.AssetsId
 LEFT JOIN PolicyManagement..TPensionInfo TPI ON TPI.PolicyBusinessId = Pd.PolicyBusinessId
WHERE  
 RefPlanTypeId IN (64) -- Equity Release.

SET NOCOUNT OFF
End

GO
