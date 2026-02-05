CREATE PROCEDURE [dbo].[SpNCustomRetrieveExistingEquityReleases] 
(
  @CRMContactId BIGINT,                            
  @CRMContactId2 BIGINT,                       
  @TenantId bigint
)
As

--DECLARE @CRMContactId BIGINT = 4670733
--DECLARE @CRMContactId2 BIGINT = 4670731
--DECLARE @TenantId BIGINT = 10155


DECLARE @PlanList TABLE (PolicyBusinessId bigint PRIMARY KEY, DetailId bigint)      
INSERT INTO @PlanList      
SELECT DISTINCT     
 PB.PolicyBusinessId, PB.PolicyDetailId      
FROM                                
  PolicyManagement..TPolicyOwner PO WITH(NOLOCK)     
  JOIN PolicyManagement..TPolicyBusiness PB WITH(NOLOCK) ON PB.PolicyDetailId = PO.PolicyDetailId
  JOIN PolicyManagement..TPolicyDetail PD WITH(NOLOCK) ON PD.PolicyDetailId = PB.PolicyDetailId         
  JOIN PolicyManagement..TPlanDescription PDS WITH(NOLOCK) ON PDS.PlanDescriptionId = PD.PlanDescriptionId    
  JOIN PolicyManagement..TRefPlanType2ProdSubType RPT WITH(NOLOCK) ON RPT.RefPlanType2ProdSubTypeId = PDS.RefPlanType2ProdSubTypeId    
  JOIN factfind..TRefPlanTypeToSection  PS WITH(NOLOCK) ON PS.RefPlanType2ProdSubTypeId = PDS.RefPlanType2ProdSubTypeId  
  JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) On Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
  JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType <> 'Deleted'  
WHERE PB.IndigoClientId = @TenantId and Ps.Section ='equity release' and 
 CRMContactId IN (@CRMContactId, @CRMContactId2)  and RPT.RefPlanTypeId IN (64) --- Equity Release.
                                
SELECT                                
 EQ.PolicyBusinessId,    
 EQ.RefEquityReleaseTypeId,
 ET.EquityReleaseType,
 EQ.PercentageOwnershipSold,
 EQ.PenaltyFg,
 EQ.RateType,  
 EQ.RefMortgageRepaymentMethodId AS RepaymentMethodId, 
 mrt.MortgageRepaymentMethod AS RepaymentMethod,                              
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
 CASE WHEN PV2.PlanValue < 0 THEN -PV2.PlanValue ELSE PV2.PlanValue END as 'CurrentBalance', 
 --CASE WHEN wrapper1.PolicyBusinessId IS NULL AND wrapper2.ParentPolicyBusinessId IS NULL
 --THEN CONVERT(BIT,0)
 --ELSE CONVERT(BIT,1) END AS IsWrapper 
 EQ.AddressStoreId,
 Addr.AddressLine1,
 Addr.AddressLine2,
 Addr.AddressLine3,
 Addr.AddressLine4,
 Addr.CityTown,
 Addr.Postcode,
 county.CountyCode,
 country.CountryCode

FROM                                
 @PlanList Pd                           
 
 LEFT JOIN PolicyManagement..TEquityRelease EQ WITH(NOLOCK) ON EQ.PolicyBusinessId = Pd.PolicyBusinessId   
 LEFT JOIN Crm..TRefEquityReleaseType ET WITH(NOLOCK) ON ET.RefEquityReleaseTypeId = EQ.RefEquityReleaseTypeId   
 LEFT JOIN policymanagement..TRefMortgageRepaymentMethod mrt WITH(NOLOCK) ON mrt.RefMortgageRepaymentMethodId = EQ.RefMortgageRepaymentMethodId
 LEFT JOIN PolicyManagement..TPolicyBusinessAttribute PBA WITH(NOLOCK) ON EQ.PolicyBusinessId = PBA.PolicyBusinessId
 LEFT JOIN PolicyManagement..TAttributeList2Attribute ALA ON ALA.AttributeList2AttributeId = PBA.AttributeList2AttributeId
 LEFT JOIN PolicyManagement..TAttributelist AL ON ALA.AttributeListId = AL.AttributeListId AND AL.Name = 'Amount Released'
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper1 WITH(NOLOCK) ON wrapper1.PolicyBusinessId = Pd.PolicyBusinessId  
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper2 WITH(NOLOCK) ON wrapper2.ParentPolicyBusinessId = Pd.PolicyBusinessId
 LEFT JOIN (Select PolicyBusinessId,Max(PlanValuationId) as PlanValuationId from policymanagement..TPlanValuation
			Group by  PolicyBusinessId)PV ON pd.PolicyBusinessId = PV.PolicyBusinessId
 LEFT JOIN policymanagement..TPlanValuation PV2 ON PV.PlanValuationId = PV2.PlanValuationId	 	
 LEFT JOIN crm..TAddressStore ADDR WITH(NOLOCK) ON ADDR.AddressStoreId = EQ.AddressStoreId	
 LEFT JOIN crm..TRefCounty county WITH(NOLOCK) ON county.RefCountyId = ADDR.RefCountyId	
 LEFT JOIN crm..TRefCountry country WITH(NOLOCK) ON country.RefCountryId = ADDR.RefCountryId
