CREATE PROCEDURE [dbo].[SpNCustomRetrieveExistingMortgages] 
(
  @CRMContactId BIGINT,                            
  @CRMContactId2 BIGINT,                       
  @TenantId bigint
)
As

DECLARE @PlanList TABLE (PolicyBusinessId bigint PRIMARY KEY, DetailId bigint, RefPlanType2ProdSubTypeId bigint, PolicyStartDate datetime, MaturityDate datetime, TotalRegularPremium money)      
INSERT INTO @PlanList      
SELECT DISTINCT     
 PB.PolicyBusinessId, PB.PolicyDetailId, PDS.RefPlanType2ProdSubTypeId, PB.PolicyStartDate, PB.MaturityDate, PB.TotalRegularPremium
FROM                                
  PolicyManagement..TPolicyOwner PO WITH(NOLOCK)     
  JOIN PolicyManagement..TPolicyBusiness PB WITH(NOLOCK) ON PB.PolicyDetailId = PO.PolicyDetailId
  JOIN PolicyManagement..TPolicyDetail PD WITH(NOLOCK) ON PD.PolicyDetailId = PB.PolicyDetailId         
  JOIN PolicyManagement..TPlanDescription PDS WITH(NOLOCK) ON PDS.PlanDescriptionId = PD.PlanDescriptionId    
  JOIN PolicyManagement..TRefPlanType2ProdSubType RPT WITH(NOLOCK) ON RPT.RefPlanType2ProdSubTypeId = PDS.RefPlanType2ProdSubTypeId    
  JOIN factfind..TRefPlanTypeToSection  PS WITH(NOLOCK) ON PS.RefPlanType2ProdSubTypeId = PDS.RefPlanType2ProdSubTypeId  
  JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) On Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
  JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType <> 'Deleted'  
WHERE PB.IndigoClientId = @TenantId and Ps.Section ='mortgage' and 
 CRMContactId IN (@CRMContactId, @CRMContactId2)  and RPT.RefPlanTypeId IN (63, 1039) -- Mortgages & Mortgage Non-Regulated.


SELECT                                
 Pb.PolicyBusinessId, 
 pb.RefPlanType2ProdSubTypeId ProductTypeId,
 pt.ProdSubTypeName ProductSubType,
 M.RefMortgageRepaymentMethodId AS RepaymentMethodId,   
 mrt.MortgageRepaymentMethod  AS RepaymentMethod,                           
 M.RefMortgageBorrowerTypeId,  
 MBT.MortgageBorrowerType RefMortgageBorrowerType,
 M.LoanAmount,  
 M.InterestRate,  
 M.InterestOnlyAmount,  
 M.RepaymentAmount,   
 M.MortgageType,                           
 M.MortgageTypeOther,  
 M.FeatureExpiryDate,  
 M.MortgageTerm,                          
CASE WHEN PV2.PlanValue < 0 THEN -PV2.PlanValue ELSE PV2.PlanValue END as 'CurrentBalance',   
 M.MortgageRefNo AS AccountNumber,                        
 M.PenaltyFg AS RedemptionFg,                           
 M.RedemptionAmount,  
 M.RedemptionTerms,  
 M.PenaltyExpiryDate AS RedemptionEndDate,                           
 M.PortableFg,  
 M.WillBeDischarged,
 M.PenaltyFg,  
 M.AssetsId AS AssetId,                           
 CASE   
  WHEN M.StatusFg = 1 THEN 'Full Status'  
  WHEN M.SelfCertFg = 1 THEN 'Self Certified'  
  WHEN M.NonStatusFg = 1 THEN 'Non Status'  
 END AS IncomeStatus,  
 M.BaseRate,  
 M.LenderFee,  
 M.IsGuarantorMortgage,  
 M.RatePeriodFromCompletionMonths,
 M.RepayDebtFg,
 Pb.TotalRegularPremium AS MonthlyRepaymentAmount,
 M.InterestOnlyRepaymentVehicle,
 M.PropertyType,
 M.CapitalRepaymentTerm as RepaymentTerm,
 M.InterestOnlyTerm,
 --CASE WHEN wrapper1.PolicyBusinessId IS NULL AND wrapper2.ParentPolicyBusinessId IS NULL
 --THEN CONVERT(BIT,0)
 --ELSE CONVERT(BIT,1) END AS IsWrapper ,
 M.IsFirstTimeBuyer,
 M.AddressStoreId,
 Addr.AddressLine1,
 Addr.AddressLine2,
 Addr.AddressLine3,
 Addr.AddressLine4,
 Addr.CityTown,
 Addr.Postcode,
 county.CountyCode,
 country.CountryCode,
 M.ProductRatePeriodInYears,
 M.Deposit,
 M.SVR AS ReversionaryRate,
 M.ConsentToLetFg,
 M.ConsentToLetExpiryDate,
 M.PercentageOwnership,
 M.SharedOwnershipBody,
 M.RentMonthly,
 rels.[Name] AS EquityLoanScheme,
 M.EquitySchemeProvider,
 M.EquityRepaymentStartDate,
 M.EquityLoanPercentage,
 M.EquityLoanAmount,
 Pb.PolicyStartDate,
 Pb.MaturityDate,
 PV2.PlanValueDate AS 'BalanceDate'
FROM                                
	@PlanList Pb                   
 INNER JOIN PolicyManagement..TMortgage M WITH(NOLOCK) ON M.PolicyBusinessId = Pb.PolicyBusinessId    
 LEFT JOIN policymanagement..TRefMortgageRepaymentMethod mrt WITH(NOLOCK) ON mrt.RefMortgageRepaymentMethodId = m.RefMortgageRepaymentMethodId
 LEFT JOIN policymanagement..TRefMortgageBorrowerType MBT WITH(NOLOCK) ON MBT.RefMortgageBorrowerTypeId = m.RefMortgageBorrowerTypeId
 --LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper1 WITH(NOLOCK) ON wrapper1.PolicyBusinessId = Pd.PolicyBusinessId  
 --LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper2 WITH(NOLOCK) ON wrapper2.ParentPolicyBusinessId = Pd.PolicyBusinessId
 LEFT JOIN (Select PolicyBusinessId, Max(PlanValuationId) as PlanValuationId from policymanagement..TPlanValuation WITH(NOLOCK)
			Group by  PolicyBusinessId)PV  ON pb.PolicyBusinessId = PV.PolicyBusinessId
 LEFT JOIN policymanagement..TPlanValuation PV2 WITH(NOLOCK) ON PV.PlanValuationId = PV2.PlanValuationId		
 LEFT JOIN crm..TAddressStore ADDR WITH(NOLOCK) ON ADDR.AddressStoreId = M.AddressStoreId	
 LEFT JOIN crm..TRefCounty county WITH(NOLOCK) ON county.RefCountyId = ADDR.RefCountyId	
 LEFT JOIN crm..TRefCountry country WITH(NOLOCK) ON country.RefCountryId = ADDR.RefCountryId	
 JOIN PolicyManagement..TRefPlanType2ProdSubType RPT WITH(NOLOCK) ON rpt.RefPlanType2ProdSubTypeId = pb.RefPlanType2ProdSubTypeId
 LEFT JOIN policymanagement..TProdSubType pt WITH(NOLOCK) ON pt.ProdSubTypeId = rpt.ProdSubTypeId
 LEFT JOIN policymanagement..TRefEquityLoanScheme rels ON rels.RefEquityLoanSchemeId = M.RefEquityLoanSchemeId



