
--use policymanagement
 
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetPlanMortgages]	
	@PolicyBusinessIds  VARCHAR(8000),
	@TenantId BIGINT	
AS


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


--DECLARE @PolicyBusinessIds  VARCHAR(8000) = '16, 22, 25, 26, 27, 28, 29, 32, 33, 34, 35, 43, 44, 47, 49, 50, 53, 54, 55, 56, 57, 58, 59, 64, 65, 66, 67, 68, 69, 70, 71, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 89, 87, 88, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 126, 127, 128, 129, 130, 131, 132, 138, 139, 140, 141, 142, 143, 144, 145, 146, 1301, 1302, 1303, 1304, 1305, 1306, 1307, 1308, 1309, 1310, 1311, 1312, 1313, 1316, 1314, 1315, 1317, 1318, 1319, 1320'
--DECLARE @TenantId bigint = 10155

 
DECLARE @pbs TABLE(PolicyBusinessId INT) 

INSERT INTO @pbs(PolicyBusinessId)
SELECT
CAST(ISNULL(Value, '0') AS INT)  
FROM policymanagement..FnSplit(@PolicyBusinessIds, ',')


SELECT 
   Pb.PolicyBusinessId                                                    as PolicyBusinessId
,  ISNULL(m.MortgageType, m.MortgageTypeOther)                            as MortgageMortgageType
,  m.InterestRate                                                         as MortgageInterestRate
,  m.LoanAmount                                                           as MortgageLoanAmount
,  m.PriceValuation                                                       as MortgagePropertyValue
,  mr.MortgageRepaymentMethod                                             as MortgageRepaymentMethodValue
,  mbt.MortgageBorrowerType                                               as MortgageTypeOfBorrowValue
,  m.MortgageTerm                                                         as MortgageTermYears
,  PDesc.RefPlanType2ProdSubTypeId                                        as PlanTypeProdSubTypeId
,  m.ProductRatePeriodInYears                                             as ProductRatePeriodInYears
,  m.LenderFee                                                            as LenderFee
,  m.PenaltyFg                                                            as PenaltyFg
,  m.PenaltyExpiryDate                                                    as PenaltyExpiryDate
,  m.RedemptionTerms                                                      as RedemptionTerms
,  m.RedemptionFigure                                                     as RedemptionFigure
,  m.RedemptionFigure2                                                    as RedemptionFigure2
,  m.NetProceed                                                           as NetProceed
FROM  TPolicyBusiness Pb   
 JOIN @pbs pl on pl.PolicyBusinessId = pb.PolicyBusinessId      
 JOIN TPolicyDetail pd WITH(NOLOCK) ON pd.PolicyDetailId = pb.PolicyDetailId              
 JOIN TPlanDescription PDesc WITH(NOLOCK) ON PDesc.PlanDescriptionId = pd.PlanDescriptionId    
 JOIN TMortgage M WITH(NOLOCK) ON M.PolicyBusinessId = pb.PolicyBusinessId  
 LEFT JOIN TRefMortgageRepaymentMethod MR ON MR.RefMortgageRepaymentMethodId = M.RefMortgageRepaymentMethodId
 LEFT JOIN TRefMortgageBorrowerType MBT ON MBT.RefMortgageBorrowerTypeId = M.RefMortgageBorrowerTypeId
WHERE
	 PB.IndigoClientId = @TenantId


 



