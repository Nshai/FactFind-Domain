SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SpNCustomRetrievePersonalExistingMortgagePlans] 
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
 @NewId bigint, @IncludeTopups bit, @TenantId bigint, @AdviserUserId bigint, @AdviserGroupId bigint, 
 @IncomeReplacementRate smallint, @UserIncomeReplacementRate smallint, @MortgagePlanType2ProdSubTypeId bigint
  
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
 
--Get the mapping id for mortgage plan type without prod sub type mapped
SELECT @MortgagePlanType2ProdSubTypeId = RefPlanType2ProdSubTypeId
FROM   policymanagement..TRefPlanType2ProdSubType as P2P
	INNER JOIN policymanagement..TRefPlanType as RPT
		ON P2P.RefPlanTypeId = RPT.RefPlanTypeId
WHERE  RPT.PlanTypeName = 'Mortgage'
	AND P2P.ProdSubTypeId IS NULL
 
 -- Mortgages                                
SELECT                                
 Pd.PolicyBusinessId as ExistingMortgageId,                                
 Pd.CRMContactId,  
 Pd.CRMContactId2, 
 Pd.[Owner],                               
 pd.SellingAdviserId,                          
 pd.SellingAdviserName,      
 Pd.RefProdProviderId,
 Pd.Provider,    
 Pd.PolicyNumber,    
 Pd.AgencyStatus,
 M.AddressStoreId,  
 M.RefMortgageRepaymentMethodId AS RepaymentMethod,                                
 M.RefMortgageBorrowerTypeId,  
 M.LoanAmount,  
 M.InterestRate,  
 M.InterestOnlyAmount,  
 M.RepaymentAmount,   
 M.MortgageType,                           
 M.FeatureExpiryDate,  
 M.MortgageTerm as MortgageTermYearsPart,  
 pd.StartDate,                            
 pd.MaturityDate,                          
 M.RemainingTerm as RemainingTermYearsPart,  
 (Select top 1 -PlanValue from policymanagement..TPlanValuation
			where PolicyBusinessId = Pd.PolicyBusinessId
			order by PlanValueDate desc, PlanValuationId desc) as 'CurrentBalance', 
 M.MortgageRefNo AS AccountNumber,                        
 M.PenaltyFg AS RedemptionFg,                           
 M.RedemptionAmount,  
 M.RedemptionTerms,  
 M.PenaltyExpiryDate AS RedemptionEndDate,                             
 M.PortableFg,  
 M.WillBeDischarged,  
 M.AssetsId AS AssetId,                           
 CASE   
  WHEN M.StatusFg = 1 THEN 'Full Status'  
  WHEN M.SelfCertFg = 1 THEN 'Self Certified'  
  WHEN M.NonStatusFg = 1 THEN 'Non Status'  
 END AS IncomeStatus,  
 Pd.ConcurrencyId,  
 M.BaseRate,   
 M.LenderFee,  
 M.IsGuarantorMortgage,   
 M.RatePeriodFromCompletionMonths,
 M.RepayDebtFg,
 pd.TotalPremium,
 M.MonthlyRepaymentAmount,
 M.InterestOnlyRepaymentVehicle,
 M.PropertyType,
 pd.ProductName,
 M.CapitalRepaymentTerm as RepaymentTermYearsPart,
 M.InterestOnlyTerm as InterestOnlyTermYearsPart,
 CASE WHEN wrapper1.PolicyBusinessId IS NULL AND wrapper2.ParentPolicyBusinessId IS NULL
 THEN CONVERT(BIT,0)
 ELSE CONVERT(BIT,1) END AS IsWrapper ,
 CASE WHEN Pd.RefPlanType2ProdSubTypeId IS NOT NULL AND Pd.RefPlanType2ProdSubTypeId != @MortgagePlanType2ProdSubTypeId
 THEN  Pd.RefPlanType2ProdSubTypeId
 ELSE NULL END AS RefPlanType2ProdSubTypeId,
 M.IsFirstTimeBuyer,
 addr.AddressLine1,
 M.ConsentToLetFg,
 M.ConsentToLetExpiryDate,
 M.PercentageOwnership,
 M.SharedOwnershipBody,
 M.RentMonthly,
 Pd.PlanCurrency,
 M.RefEquityLoanSchemeId,
 M.EquitySchemeProvider,
 M.EquityRepaymentStartDate,
 M.EquityLoanPercentage,
 M.EquityLoanAmount,
 M.AddressId,
 assets.Amount as AssetAmount,
 assets.CurrencyCode as CurrencyCode,
 M.IsToBeConsolidated as Consolidate,
 M.IsLiabilityToBeRepaid as IsToBeRepaid,
 M.LiabilityRepaymentDescription as LiabilityRepaymentDescription,
 Pd.ValuationDate as 'BalanceDate',
 Pd.SequentialRef,
 Pd.IsProviderManaged,
 Tp.PensionArrangement,
 Tp.CrystallisationStatus,
 Tp.HistoricalCrystallisedPercentage,
 Tp.CurrentCrystallisedPercentage,
 Tp.CrystallisedPercentage,
 Tp.UncrystallisedPercentage
FROM
 @PlanDescription Pd
 LEFT JOIN PolicyManagement..TMortgage M WITH(NOLOCK) ON M.PolicyBusinessId = Pd.PolicyBusinessId   
 LEFT JOIN CRM..TAddress A WITH (NOLOCK) ON M.AddressId = A.AddressId
 LEFT JOIN CRM..TAddressStore addr WITH (NOLOCK) ON A.AddressStoreId = addr.AddressStoreId
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper1 WITH(NOLOCK) ON wrapper1.PolicyBusinessId = Pd.PolicyBusinessId  
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper2 WITH(NOLOCK) ON wrapper2.ParentPolicyBusinessId = Pd.PolicyBusinessId
 LEFT JOIN factfind..TAssets assets WITH(NOLOCK) ON M.AssetsId = assets.AssetsId
 LEFT JOIN PolicyManagement..TPensionInfo Tp ON Tp.PolicyBusinessId = Pd.PolicyBusinessId 
WHERE
 RefPlanTypeId IN (63, 1039, 84, 1078) -- Mortgages, Mortgage Non-Regulated, Conveyancing Servicing Plan & Loan
SET NOCOUNT OFF
End
