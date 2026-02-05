SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
CREATE PROCEDURE [dbo].[SpNCustomRetrievePersonalMortgageRequirementPlans]     
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
  
  
  
-- Find Opportunities for the FF clients    
DECLARE @Opps TABLE (Id bigint)    
INSERT INTO @Opps     
SELECT    
 OpportunityId   
FROM    
 CRM..TOpportunityCustomer     
WHERE    
 PartyId IN (@CRMContactId, @CRMContactId2)        
         
     
     
--Case 18213 Mortgages                    
SELECT              
 TMOp.MortgageOpportunityId AS MortgageRequirementsId,                                  
 T.SequentialRef,                    
 -- Get owners, these are then managed in c#    
 OC1.PartyId AS CRMContactId,   
 CASE WHEN OC2.PartyId != OC1.PartyId THEN OC2.PartyId END AS CRMContactId2,   
 CASE Owners.OwnerCount  
  WHEN 1 THEN                                
   CASE OC1.PartyId                                
    WHEN @CRMContactId THEN 'Client 1'                                
    ELSE 'Client 2'                                
   END                                
  ELSE 'Joint'                                    
 END AS Owner,  
 RefMortgageBorrowerTypeId,    
 --RefMortgageBorrowerTypeId as RefPlanType2ProdSubTypeId,  
  CASE @ExcludePlanPurposes     
  WHEN 1 THEN ''    
  ELSE ISNULL(TMOp.PlanPurpose,'')    
 END AS PlanPurposeText,  
 TMOp.LoanPurpose,     
 TMOp.RefMortgageRepaymentMethodId,                       
 TMOp.RefMortgageRepaymentMethodId as RepaymentMethod,                       
 TMOp.RepaymentAmountMonthly,    
 TMOp.PlanPurpose,    
 TMOp.Price,    
 TMOp.Deposit,    
 TMOp.LoanAmount,    
 TMOp.LTV,    
 TMOp.Term,                                  
 TMOp.InterestOnly,    
 TMOp.Repayment,    
 TMOp.CurrentLender,
 TMOp.CurrentLenderId,    
 TMOp.CurrentLoanAmount,    
 TMOp.MonthlyRentalIncome,    
 TMOp.ConcurrencyId,  
 TMOp.SourceOfDeposit,  
 TMOp.InterestOnlyRepaymentVehicle,  
 TMOp.RelatedAddressStoreId,  
 TMOp.RepaymentOfExistingMortgage,  
 TMOp.HomeImprovements,  
 TMOp.MortgageFees,  
 TMOp.Other as MROther,  
 TMOp.GuarantorMortgageFg as IsGuarantorMortgage,  
 TMOp.GuarantorText as  GuarantorText,  
 TMOp.DebtConsolidatedFg as IsDebtConsolidated,  
 TMOp.DebtConsolidationText as DebtConsolidationText,  
 TMOp.RepaymentTerm,  
 TMOp.InterestOnlyTerm,
 TMOp.Details,
 TMOp.RefMortgageSaleTypeId,
 TMOp.IsHighNetWorthClient,
 TMOp.IsMortgageForBusiness,
 TMOp.IsProfessionalClient,
 TMOp.IsRejectedAdvice,
 TMOp.ExecutionOnlyDetails,
 TMOp.RefOpportunityType2ProdSubTypeId,
 TMOp.IsFirstTimeBuyer,
 CASE OT.OpportunityTypeName  
  WHEN 'Equity Release' THEN CAST(1 AS BIT)                                
  ELSE CAST(0 AS BIT)                                  
 END AS IsEquityRelease,
 TMOp.RefEquityReleaseTypeId,
 TMOp.PercentageOwnershipSold,
 TMOp.LumpsumAmount,
 TMOp.MonthlyIncomeAmount,
 TMOp.EquityLoanAmount,
 TMOp.EquityLoanPercentage
FROM    
 CRM..TMortgageOpportunity  TMOp WITH(NOLOCK)                             
 JOIN CRM..TOpportunity T WITH(NOLOCK) on TMOp.OpportunityId = T.OpportunityId 
 JOIN CRM..TOpportunityType OT WITH(NOLOCK) on T.OpportunityTypeId = OT.OpportunityTypeId   
 JOIN (    
  SELECT     
   OpportunityId,       
   MIN(OpportunityCustomerId) AS FirstOwnerId,    
   MAX(OpportunityCustomerId) AS SecondOwnerId,  
   COUNT(OpportunityCustomerId)   AS OwnerCount  
  FROM       
   CRM..TOpportunityCustomer OC WITH(NOLOCK)     
  WHERE     
   OpportunityId IN (SELECT Id FROM @Opps)    
  GROUP BY     
   OpportunityId) AS Owners ON Owners.OpportunityId = T.OpportunityId    
 JOIN CRM..TOpportunityCustomer OC1 WITH(NOLOCK) ON OC1.OpportunityCustomerId = Owners.FirstOwnerId    
 JOIN CRM..TOpportunityCustomer OC2 WITH(NOLOCK) ON OC2.OpportunityCustomerId = Owners.SecondOwnerId    
WHERE     
 T.OpportunityId IN (SELECT Id FROM @Opps)     
 AND ISNULL(T.IsClosed,0) = 0                            
ORDER BY    
 SequentialRef desc                            
   
SET NOCOUNT OFF
End    
GO
