SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveTrustLiabilities] 
(
  @CRMContactId BIGINT,                                          
  @TenantId bigint
)
AS

BEGIN


DECLARE @PlanList TABLE (
	PolicyBusinessId bigint PRIMARY KEY, 
	MaturityDate datetime, 
	LastPlanValuationId bigint,
	RefPlanDiscriminatorId bigint
)   
INSERT INTO @PlanList      
	SELECT DISTINCT     
		PB.PolicyBusinessId, PB.MaturityDate,
	PolicyManagement.dbo.[FnCustomGetLatestPlanValuationIdByValuationDate](PB.PolicyBusinessId) AS LastPlanValuationId,
	discriminator.RefPlanDiscriminatorId
FROM                                
	TPolicyOwner PO WITH(NOLOCK)     
	JOIN TPolicyBusiness PB WITH(NOLOCK) ON PB.PolicyDetailId = PO.PolicyDetailId
	JOIN TPolicyDetail PD WITH(NOLOCK) ON PD.PolicyDetailId = PB.PolicyDetailId         
	JOIN TPlanDescription PDS WITH(NOLOCK) ON PDS.PlanDescriptionId = PD.PlanDescriptionId    
	JOIN TRefPlanType2ProdSubType RPT WITH(NOLOCK) ON RPT.RefPlanType2ProdSubTypeId = PDS.RefPlanType2ProdSubTypeId    
	JOIN TRefPlanDiscriminator discriminator ON RPT.RefPlanDiscriminatorId = discriminator.RefPlanDiscriminatorId
	JOIN TStatusHistory Sh WITH(NOLOCK) On Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
	JOIN TStatus St WITH(NOLOCK) ON st.StatusId = Sh.StatusId  

WHERE PB.IndigoClientId = @TenantId AND
	St.IntelligentOfficeStatusType <> 'Deleted' AND
	CRMContactId = @CRMContactId 
	AND discriminator.RefPlanDiscriminatorId IN 
	(
		12, -- mortgage
		13, -- equity release
		14 --loan credit
	) 
ORDER BY PolicyBusinessId


SELECT 
	1																				AS IsMortgage,																			
	NULL																			AS IsEquityRelease,
	NULL																			AS IsLoanCredit,
	@CRMContactId																	AS CRMContactId,
	Pl.PolicyBusinessId, 
	PB.PolicyDetailId,
	PB.PolicyStartDate,
	PB.MaturityDate,
	M.MortgageType																	AS RateType,
	M.ProductRatePeriodInYears,
	M.Deposit,
	M.RatePeriodFromCompletionMonths,
	M.IsFirstTimeBuyer,
	M.PropertyType,
	M.RefMortgageRepaymentMethodId													AS RepaymentMethodId,   
	mrt.MortgageRepaymentMethod														AS RepaymentMethod, 
	M.RepaymentAmount,   
	M.CapitalRepaymentTerm															AS RepaymentTerm,
	M.InterestOnlyAmount, 
	M.InterestOnlyTerm, 
	M.InterestOnlyRepaymentVehicle,
	M.MonthlyRepaymentAmount,
    M.LoanAmount, 
	M.RefEquityLoanSchemeId															AS EquityLoanScheme,
	M.EquitySchemeProvider,
	M.EquityRepaymentStartDate,
	M.EquityLoanPercentage,
	M.EquityLoanAmount,
	M.LenderFee,
	M.SVR																			AS ReversionaryRate,
	M.InterestRateAPR																AS InterestRateAPR,
	M.BaseRate,  
	M.FeatureExpiryDate,  
	M.MortgageTerm,                          
	CASE WHEN Val.PlanValue < 0 THEN -Val.PlanValue ELSE Val.PlanValue END			AS 'CurrentBalance',   
	M.MortgageRefNo																	AS AccountNumber, 
	M.IsGuarantorMortgage,  
	M.ConsentToLetFg,
	M.ConsentToLetExpiryDate,
	M.PenaltyFg,                           
	M.RedemptionTerms																AS RedemptionTerms,  
	M.PenaltyExpiryDate																AS RedemptionEndDate,
	M.PortableFg,  
	M.WillBeDischarged,
	CASE   
	  WHEN M.StatusFg = 1 THEN 'Full Status'  
	  WHEN M.SelfCertFg = 1 THEN 'Self Certified'  
	  WHEN M.NonStatusFg = 1 THEN 'Non Status'  
	END																				AS IncomeStatus,

	M.IsToBeConsolidated															AS IsConsolidated,
	M.IsLiabilityToBeRepaid															AS IsToBeRepaid,
	M.LiabilityRepaymentDescription													AS HowWillItBeRepaid,
	NULL																			AS RefEquityReleaseTypeId,
	NULL																			AS EquityReleaseType,
	M.InterestRate																	AS InterestRatePercentage,  
	NULL																			AS LumpsumAmount,
	NULL																			AS MonthlyIncomeAmount,
	PBA.AttributeValue																AS AmountReleased,
	NULL																			AS LoanType,
	NULL																			AS AmountOutstanding,
	NULL																			AS CreditLimit,
	M.MonthlyRepaymentAmount														AS PaymentAmountPerMonth,
	NULL																			AS PaymentFrequency, -- RF.FrequencyName AS PaymentFrequency,
	NULL																			AS LoanTerm,
	NULL																			AS Protected,
	NULL																			AS EndDate,
	M.RepayDebtFg																	AS RepayDebt,
	M.AddressStoreId																AS AddressStoreId,
	Addr.AddressLine1,
	Addr.AddressLine2,
	Addr.AddressLine3,
	Addr.AddressLine4,
	Addr.CityTown,
	Addr.Postcode,
	county.CountyCode,
	country.CountryCode,
	M.RedemptionFigure,
	M.RedemptionFigure2,
	M.NetProceed

FROM                                
	@PlanList Pl     
	INNER JOIN TPolicyBusiness PB WITH(NOLOCK)  ON PB.PolicyBusinessId = Pl.PolicyBusinessId
	INNER JOIN TPolicyBusinessExt PBE WITH(NOLOCK) ON PBE.PolicyBusinessId = Pb.PolicyBusinessId
	LEFT JOIN TMortgage M WITH(NOLOCK) ON M.PolicyBusinessId = Pb.PolicyBusinessId    
	LEFT JOIN TPolicyBusinessAttribute PBA WITH(NOLOCK) ON M.PolicyBusinessId = PBA.PolicyBusinessId
	LEFT JOIN TRefMortgageRepaymentMethod mrt WITH(NOLOCK) ON mrt.RefMortgageRepaymentMethodId = m.RefMortgageRepaymentMethodId
	LEFT JOIN crm..TAddress AD WITH(NOLOCK) ON AD.AddressId = M.AddressId
	LEFT JOIN crm..TAddressStore ADDR WITH(NOLOCK) ON ADDR.AddressStoreId = AD.AddressStoreId
	LEFT JOIN crm..TRefCounty county WITH(NOLOCK) ON county.RefCountyId = ADDR.RefCountyId	
	LEFT JOIN crm..TRefCountry country WITH(NOLOCK) ON country.RefCountryId = ADDR.RefCountryId	
	LEFT JOIN TPlanValuation Val ON Val.PlanValuationId = Pl.LastPlanValuationId 

	WHERE Pl.RefPlanDiscriminatorId = 12
	
UNION ALL

-- Equity Release

SELECT     
	NULL																			AS IsMortgage,																			
	1																				AS IsEquityRelease,
	NULL																			AS IsLoanCredit,
	@CRMContactId																	AS CRMContactId,
	Pl.PolicyBusinessId, 
	PB.PolicyDetailId,
	PB.PolicyStartDate,
	PB.MaturityDate,
	EQ.RateType,
	NULL																			AS ProductRatePeriodInYears,
	EQ.DepositPerEquity																AS Deposit,
	NULL																			AS RatePeriodFromCompletionMonths,
	NULL																			AS IsFirstTimeBuyer,
	NULL																			AS PropertyType,
	EQ.RefMortgageRepaymentMethodId													AS RepaymentMethodId,   
	mrt.MortgageRepaymentMethod														AS RepaymentMethod, 
	EQ.RepaymentAmount,   
	NULL																			AS RepaymentTerm,
	EQ.InterestOnlyAmount, 
	NULL																			AS InterestOnlyTerm, 
	NULL																			AS InterestOnlyRepaymentVehicle,
	NULL																			AS MonthlyRepaymentAmount,
    EQ.LoanAmount, 
	NULL																			AS EquityLoanScheme,
	NULL																			AS EquitySchemeProvider,
	NULL																			AS EquityRepaymentStartDate,
	NULL																			AS EquityLoanPercentage,
	NULL																			AS EquityLoanAmount,
	NULL																			AS LenderFee,
	NULL																			AS ReversionaryRate,
	EQ.InterestRate																	AS InterestRateAPR,
	EQ.BaseRate,  
	NULL																			AS FeatureExpiryDate,  
	NULL																			AS MortgageTerm,                          
	CASE WHEN Val.PlanValue < 0 THEN -Val.PlanValue ELSE Val.PlanValue END			AS 'CurrentBalance',   
	NULL																			AS AccountNumber, 
	NULL																			AS IsGuarantorMortgage,  
	NULL																			AS ConsentToLetFg,
	NULL																			AS ConsentToLetExpiryDate,
	EQ.PenaltyFg,                           
	EQ.RedemptionTerms																AS RedemptionTerms,  
	EQ.PenaltyExpiryDate															AS RedemptionEndDate,
	NULL																			AS PortableFg,  
	NULL																			AS WillBeDischarged,
	NULL																			AS IncomeStatus,

	EQ.IsToBeConsolidated															AS IsConsolidated,
	EQ.IsLiabilityToBeRepaid														AS IsToBeRepaid,
	EQ.LiabilityRepaymentDescription												AS HowWillItBeRepaid,
	EQ.RefEquityReleaseTypeId,
	ET.EquityReleaseType,
	EQ.InterestRatePercentage														AS InterestRatePercentage,  
	EQ.LumpsumAmount,
	EQ.MonthlyIncomeAmount,
	PBA.AttributeValue																AS AmountReleased,
	NULL																			AS LoanType,
	Val.PlanValue																	AS AmountOutstanding,
	NULL																			AS CreditLimit,
	NULL																			AS PaymentAmountPerMonth,
	NULL																			AS PaymentFrequency, -- RF.FrequencyName AS PaymentFrequency,
	NULL																			AS LoanTerm,
	NULL																			AS Protected,
	NULL																			AS EndDate,
	NULL																			AS RepayDebt,
	EQ.AddressStoreId																AS AddressStoreId,
	Addr.AddressLine1,
	Addr.AddressLine2,
	Addr.AddressLine3,
	Addr.AddressLine4,
	Addr.CityTown,
	Addr.Postcode,
	county.CountyCode,
	country.CountryCode,
	NULL                                                                            AS RedemptionFigure,
	NULL                                                                            AS RedemptionFigure2,
	NULL                                                                            AS NetProceed
 

FROM                                
	@PlanList Pl     
	INNER JOIN TPolicyBusiness PB WITH(NOLOCK)  ON PB.PolicyBusinessId = Pl.PolicyBusinessId
	INNER JOIN TPolicyBusinessExt PBE WITH(NOLOCK) ON PBE.PolicyBusinessId = Pb.PolicyBusinessId
	LEFT JOIN TEquityRelease EQ WITH(NOLOCK) ON EQ.PolicyBusinessId = Pb.PolicyBusinessId   
	LEFT JOIN Crm..TRefEquityReleaseType ET WITH(NOLOCK) ON ET.RefEquityReleaseTypeId = EQ.RefEquityReleaseTypeId   
	LEFT JOIN TPolicyBusinessAttribute PBA WITH(NOLOCK) ON EQ.PolicyBusinessId = PBA.PolicyBusinessId
	LEFT JOIN TRefMortgageRepaymentMethod mrt WITH(NOLOCK) ON mrt.RefMortgageRepaymentMethodId = EQ.RefMortgageRepaymentMethodId
	LEFT JOIN crm..TAddress AD WITH(NOLOCK) ON AD.AddressId = EQ.AddressId
	LEFT JOIN crm..TAddressStore ADDR WITH(NOLOCK) ON ADDR.AddressStoreId = AD.AddressStoreId
	LEFT JOIN crm..TRefCounty county WITH(NOLOCK) ON county.RefCountyId = ADDR.RefCountyId	
	LEFT JOIN crm..TRefCountry country WITH(NOLOCK) ON country.RefCountryId = ADDR.RefCountryId	
	LEFT JOIN TPlanValuation Val ON Val.PlanValuationId = Pl.LastPlanValuationId 

	WHERE Pl.RefPlanDiscriminatorId = 13

UNION ALL

-- Loan Credit
	 
SELECT     
	NULL																			AS IsMortgage,																			
	NULL																			AS IsEquityRelease,
	1																				AS IsLoanCredit,
	@CRMContactId																	AS CRMContactId,
	Pl.PolicyBusinessId, 
	PB.PolicyDetailId,
	PB.PolicyStartDate,
	PB.MaturityDate,
	rt.Name																			AS RateType,
	NULL																			AS ProductRatePeriodInYears,
	NULL																			AS Deposit,
	NULL																			AS RatePeriodFromCompletionMonths,
	NULL																			AS IsFirstTimeBuyer,
	NULL																			AS PropertyType,
	NULL																			AS RepaymentMethodId,   
	NULL																			AS RepaymentMethod, 
	NULL																			AS RepaymentAmount,   
	NULL																			AS RepaymentTerm,
	NULL																			AS InterestOnlyAmount, 
	NULL																			AS InterestOnlyTerm, 
	NULL																			AS InterestOnlyRepaymentVehicle,
	NULL																			AS MonthlyRepaymentAmount,
    LC.OriginalLoanAmount															AS LoanAmount, 
	NULL																			AS EquityLoanScheme,
	NULL																			AS EquitySchemeProvider,
	NULL																			AS EquityRepaymentStartDate,
	NULL																			AS EquityLoanPercentage,
	NULL																			AS EquityLoanAmount,
	NULL																			AS LenderFee,
	NULL																			AS ReversionaryRate,
	NULL																			AS InterestRateAPR,
	NULL																			AS BaseRate,  
	NULL																			AS FeatureExpiryDate,  
	NULL																			AS MortgageTerm,                          
	CASE WHEN Val.PlanValue < 0 THEN -Val.PlanValue ELSE Val.PlanValue END			AS 'CurrentBalance',   
	NULL																			AS AccountNumber, 
	NULL																			AS IsGuarantorMortgage,  
	NULL																			AS ConsentToLetFg,
	NULL																			AS ConsentToLetExpiryDate,
	NULL																			AS PenaltyFg,                           
	LC.RedemptionTerms																AS RedemptionTerms,  
	NULL																			AS RedemptionEndDate,
	NULL																			AS PortableFg,  
	NULL																			AS WillBeDischarged,
	NULL																			AS IncomeStatus,
	LC.IsToBeConsolidated															AS IsConsolidated,
	LC.IsLiabilityToBeRepaid														AS IsToBeRepaid,
	LC.LiabilityRepaymentDescription												AS HowWillItBeRepaid,
	NULL																			AS RefEquityReleaseTypeId,
	NULL																			AS EquityReleaseType,
	PBE.InterestRate																	AS InterestRatePercentage,  
	NULL																			AS LumpsumAmount,
	NULL																			AS MonthlyIncomeAmount,
	PBA.AttributeValue																AS AmountReleased,
	RLCT.[Name]																		AS LoanType,
	Val.PlanValue																	AS AmountOutstanding,
	LC.CreditLimit,
	NULL																			AS PaymentAmountPerMonth,
	FR.FrequencyName																AS PaymentFrequency,
	LC.LoanTermInMonths																AS LoanTerm,
	prot.Name																		AS Protected,
	NULL																		    AS EndDate,
	NULL																			AS RepayDebt,
	NULL																			AS AddressStoreId,
	NULL																			AS AddressLine1,
	NULL                                                                            AS AddressLine2,
	NULL																			AS AddressLine3,
	NULL																			AS AddressLine4,
	NULL																			AS CityTown,
	NULL																			AS Postcode,
	NULL																			AS CountyCode,
	NULL																			AS CountryCode,
	NULL                                                                            AS RedemptionFigure,
	NULL                                                                            AS RedemptionFigure2,
	NULL                                                                            AS NetProceed

FROM                                
	@PlanList Pl     
	INNER JOIN TPolicyBusiness PB WITH(NOLOCK)  ON PB.PolicyBusinessId = Pl.PolicyBusinessId
	INNER JOIN TPolicyBusinessExt PBE WITH(NOLOCK) ON PBE.PolicyBusinessId = Pb.PolicyBusinessId
	LEFT JOIN TLoanCredit LC WITH(NOLOCK) ON LC.PolicyBusinessId = Pb.PolicyBusinessId
	OUTER APPLY (SELECT TOP 1 * FROM TPolicyMoneyIn c WHERE  PB.PolicyBusinessId = c.PolicyBusinessId
				AND c.CurrentFg = 1 AND c.RefContributionTypeId = 1 AND c.RefContributorTypeId = 1
				AND c.RefFrequencyId <> 10 AND c.StartDate <= CAST( GETDATE() AS Date )
                    ORDER  BY c.PolicyMoneyInId DESC) contrib
	LEFT JOIN TRefFrequency FR ON FR.RefFrequencyId = contrib.RefFrequencyId
	LEFT JOIN TRefProtectionType prot WITH(NOLOCK) ON prot.RefProtectionTypeId = lc.RefProtectionTypeId
	LEFT JOIN TRefLoanCreditType RLCT WITH(NOLOCK) ON RLCT.RefLoanCreditTypeId = LC.RefLoanCreditTypeId
	LEFT JOIN TPolicyBusinessAttribute PBA WITH(NOLOCK) ON PB.PolicyBusinessId = PBA.PolicyBusinessId
	LEFT JOIN TRefRateType rt ON rt.RefRateTypeId = LC.RefRateTypeId
	LEFT JOIN TPlanValuation Val ON Val.PlanValuationId = Pl.LastPlanValuationId 
	
	WHERE Pl.RefPlanDiscriminatorId = 14

	ORDER BY pL.PolicyBusinessId

END
GO