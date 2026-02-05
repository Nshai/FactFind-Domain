
CREATE PROCEDURE [dbo].[SpNCustomRetrieveMortgageRequirements] 
(
  @CRMContactId BIGINT,   
  @CRMContactId2 BIGINT,                         
  @TenantId BIGINT
)
As

--DECLARE @CRMContactId BIGINT = 4670733
--DECLARE @CRMContactId2 BIGINT = 4670731
--DECLARE @TenantId BIGINT = 10155
  
-- Find Opportunities for the FF clients    

DECLARE @Opps TABLE (Id bigint)    
INSERT INTO @Opps     
SELECT    
 OpportunityId   
FROM    
 CRM..TOpportunityCustomer     
WHERE    
 PartyId IN (@CRMContactId, @CRMContactId2)        
      
            
SELECT     
 TMOp.MortgageOpportunityId AS MortgageRequirementsId,                                  
 T.SequentialRef,               
 OC1.PartyId AS CRMContactId,   
 CASE WHEN OC2.PartyId != OC1.PartyId THEN OC2.PartyId END AS CRMContactId2,   
 CASE Owners.OwnerCount  
  WHEN 1 THEN                                
   CASE OC1.PartyId                                
    WHEN @CRMContactId THEN 'Client 1'                                
    ELSE 'Client 2'                                
   END                                
  ELSE 'Joint'                                    
 END AS [Owner],  
 CASE WHEN ISNULL(TMOp.RefOpportunityType2ProdSubTypeId, 0)<> 0
 THEN PST.ProdSubTypeName ELSE NULL END MortgageType, 
 TMOp.IsFirstTimeBuyer,
 TMOp.RefMortgageBorrowerTypeId AS MortgageBorrowerTypeId,   
 MBT.MortgageBorrowerType, 
 ISNULL(TMOp.PlanPurpose,'')    AS PlanPurpose,  
 TMOp.LoanPurpose,     
 TMOp.RefMortgageRepaymentMethodId as RepaymentMethodId,                       
 MRM.MortgageRepaymentMethod as RepaymentMethod,                       
 TMOp.RepaymentAmountMonthly,    

 TMOp.Price,    
 TMOp.Deposit,    
 TMOp.LoanAmount,    
 TMOp.LTV,    
 TMOp.Term,                                  
 TMOp.InterestOnly,    
 TMOp.Repayment,    
 TMOp.CurrentLender,    
 TMOp.CurrentLoanAmount,    
 TMOp.MonthlyRentalIncome,     
 TMOp.SourceOfDeposit,  
 TMOp.InterestOnlyRepaymentVehicle,  
 TMOp.RepaymentOfExistingMortgage,  
 TMOp.HomeImprovements,  
 TMOp.MortgageFees,  
 TMOp.Other as MROther,  
 TMOp.Details MROtherDetails,
 TMOp.GuarantorMortgageFg as IsGuarantorMortgage,  
 TMOp.GuarantorText as  GuarantorText,  
 TMOp.DebtConsolidatedFg as IsDebtConsolidated,  
 TMOp.DebtConsolidationText as DebtConsolidationText,  
 TMOp.DebtConsolidation as DebtConsolidation,  
 TMOp.RepaymentTerm,  
 TMOp.InterestOnlyTerm,
 
 TMOp.RefMortgageSaleTypeId AS MortgageSaleTypeId,
 MST.MortgageSaleType,
 TMOp.IsHighNetWorthClient,
 TMOp.IsMortgageForBusiness,
 TMOp.IsProfessionalClient,
 TMOp.IsRejectedAdvice,
 TMOp.ExecutionOnlyDetails,
 CASE OT.OpportunityTypeName  
  WHEN 'Equity Release' THEN CAST(1 AS BIT)                                
  ELSE CAST(0 AS BIT)                                  
 END AS IsEquityRelease,
 TMOp.RefEquityReleaseTypeId EquityReleaseTypeId,
 EQT.EquityReleaseType,
 TMOp.PercentageOwnershipSold,
 TMOp.LumpsumAmount,
 TMOp.MonthlyIncomeAmount,

 TMOp.RelatedAddressStoreId AddressStoreId,
 
 CASE ISNULL(PDT.RelatedAddressStoreId, 0) 
  WHEN 0 THEN PDT.AddressLine1                                
  ELSE Addr.AddressLine1                                
 END AS AddressLine1,

 CASE ISNULL(PDT.RelatedAddressStoreId, 0) 
  WHEN 0 THEN PDT.AddressLine2                                
  ELSE Addr.AddressLine2                                
 END AS AddressLine2,

 CASE ISNULL(PDT.RelatedAddressStoreId, 0) 
  WHEN 0 THEN PDT.AddressLine3                                
  ELSE Addr.AddressLine3                                
 END AS AddressLine3,

 CASE ISNULL(PDT.RelatedAddressStoreId, 0) 
  WHEN 0 THEN PDT.AddressLine4                                
  ELSE Addr.AddressLine4                                
 END AS AddressLine4,

 CASE ISNULL(PDT.RelatedAddressStoreId, 0) 
  WHEN 0 THEN PDT.CityTown                                
  ELSE Addr.CityTown                                
 END AS CityTown,

 CASE ISNULL(PDT.RelatedAddressStoreId, 0) 
  WHEN 0 THEN PDT.Postcode                                
  ELSE Addr.Postcode                                
 END AS Postcode,

 CASE ISNULL(PDT.RelatedAddressStoreId, 0) 
  WHEN 0 THEN PCNT.CountyCode                                
  ELSE CNT.CountyCode                                
 END AS CountyCode,

  CASE ISNULL(PDT.RelatedAddressStoreId, 0) 
  WHEN 0 THEN PCNRT.CountryCode                                
  ELSE CNRT.CountryCode                                
 END AS CountryCode

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
 LEFT JOIN policymanagement..TRefMortgageBorrowerType MBT WITH(NOLOCK) ON MBT.RefMortgageBorrowerTypeId =  TMOp.RefMortgageBorrowerTypeId  
 LEFT JOIN policymanagement..TRefMortgageRepaymentMethod MRM WITH(NOLOCK) ON MRM.RefMortgageRepaymentMethodId =  TMOp.RefMortgageRepaymentMethodId
 LEFT JOIN policymanagement..TRefMortgageSaleType MST WITH(NOLOCK)ON MST.RefMortgageSaleTypeId = TMOp.RefMortgageSaleTypeId
 LEFT JOIN crm..TRefEquityReleaseType EQT WITH(NOLOCK)ON EQT.RefEquityReleaseTypeId = TMOp.RefEquityReleaseTypeId
 LEFT JOIN factfind..TPropertyDetail PDT WITH(NOLOCK)ON PDT.PropertyDetailId = TMOp.RelatedAddressStoreId	
 LEFT JOIN crm..TAddressStore ADDR WITH(NOLOCK) ON ADDR.AddressStoreId = PDT.RelatedAddressStoreId
 LEFT JOIN crm..TRefCounty CNT WITH(NOLOCK) ON CNT.RefCountyId = ADDR.RefCountyId	
 LEFT JOIN crm..TRefCountry CNRT WITH(NOLOCK) ON CNRT.RefCountryId = ADDR.RefCountryId
  LEFT JOIN crm..TRefCounty PCNT WITH(NOLOCK) ON PCNT.RefCountyId = PDT.RefCountyId	
 LEFT JOIN crm..TRefCountry PCNRT WITH(NOLOCK) ON PCNRT.RefCountryId = PDT.RefCountryId
 LEFT JOIN crm..TRefOpportunityType2ProdSubType OST ON OST.RefOpportunityType2ProdSubTypeId = TMOp.RefOpportunityType2ProdSubTypeId
 LEFT JOIN policymanagement..TProdSubType PST on PST.ProdSubTypeId = OST.ProdSubTypeId

WHERE     
 T.OpportunityId IN (SELECT Id FROM @Opps) and T.IndigoClientId = @TenantId
 AND ISNULL(T.IsClosed,0) = 0                            
ORDER BY    
 SequentialRef desc   

