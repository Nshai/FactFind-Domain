
SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SPNCustomRetrieveRecommendationTransactionFundsForScenario] 
(
	 @ActionPlanIds VARCHAR(8000),
	 @ManualRecommendationIds VARCHAR(8000)	
)
AS
BEGIN

--declare  @ActionPlanIds VARCHAR(8000) = '1,2'
	IF(OBJECT_ID('tempdb..#Funds')IS NOT NULL)
	DROP TABLE #Funds
	
	SELECT 
		DISTINCT
		CAST(fps.FinancialPlanningScenarioId AS VARCHAR(100))+'O'													as RecommendationId,
		CAST(ap.ActionPlanId AS VARCHAR(100))+'O'																	as TransactionId,
		ap.FinancialPlanningId																						as FinancialPlanningId,		
		apf.PercentageAllocation																					as PercentageAllocation,
		apf.PolicyBusinessFundId																					as PolicyBusinessFundId,	
		ap.PolicyBusinessId																							as PolicyBusinessId,
		apf.AssetFundId																								as AssetFundId,
		aFund.Amount																							    as AssetCurrentValue,
		apf.FundId																								    as FundId,
		apf.FundUnitId																								as FundUnitId,
		apf.UnknownFundName																							as UnknownFundName,
		apf.AddManualFundIfFundUnknown																				as AddManualFundIfFundUnknown
	INTO #Funds
	FROM factfind..TActionPlan ap
	JOIN factfind..TFinancialPlanningScenario fps ON fps.FinancialPlanningId = ap.FinancialPlanningId
	INNER JOIN policymanagement.dbo.FnSplit(@ActionPlanIds, ',') parslist   ON ap.ActionPlanId = parslist.Value 
	JOIN factfind..TActionFund apf ON apf.ActionPlanId = ap.ActionPlanId	
	LEFT JOIN fund2..TFund fund ON apf.FundId = fund.FundId
	LEFT JOIN fund2..TFundUnit fundunit ON apf.FundUnitId = fundunit.FundUnitId
	LEFT JOIN factfind..TAssets aFund ON aFund.AssetsId = apf.AssetFundId
	
	UNION

	SELECT 
		DISTINCT
		CAST(ma.ManualRecommendationId AS VARCHAR(100))+'M'													        as RecommendationId,
		CAST(ma.ManualRecommendationActionId AS VARCHAR(100))+'M'													as TransactionId,
		fps.FinancialPlanningId																						as FinancialPlanningId,		
		apf.PercentageAllocation																					as PercentageAllocation,
		apf.PolicyBusinessFundId																					as PolicyBusinessFundId,	
		ma.PolicyBusinessId																							as PolicyBusinessId,
		apf.AssetFundId																								as AssetFundId,
		aFund.Amount																							    as AssetCurrentValue,
		apf.FundId																								    as FundId,
		apf.FundUnitId																								as FundUnitId,
		apf.UnknownFundName																							as UnknownFundName,
		apf.AddManualFundIfFundUnknown																				as AddManualFundIfFundUnknown
	FROM   
	FactFind.dbo.TManualRecommendationAction ma WITH(NOLOCK) 
	INNER JOIN policymanagement.dbo.FnSplit(@ManualRecommendationIds, ',') parslist   ON ManualRecommendationActionId = parslist.Value 
	JOIN FactFind.dbo.[TManualRecommendation] mr WITH(NOLOCK) ON ma.ManualRecommendationId = mr.ManualRecommendationId	
	JOIN FactFind.dbo.[TFinancialPlanningSession] fps WITH(NOLOCK) ON fps.FinancialPlanningSessionId = mr.FinancialPlanningSessionId 
	JOIN factfind..TActionFund apf ON apf.ManualRecommendationActionId = ma.ManualRecommendationActionId	
	LEFT JOIN fund2..TFund fund ON apf.FundId = fund.FundId
	LEFT JOIN fund2..TFundUnit fundunit ON apf.FundUnitId = fundunit.FundUnitId
	LEFT JOIN factfind..TAssets aFund ON aFund.AssetsId = apf.AssetFundId

	SELECT 
		
		RecommendationId																							as RecommendationId,
		TransactionId																								as TransactionId,
		FinancialPlanningId																							as FinancialPlanningId,	
	CASE 
		WHEN (ISNULL(fundunit.FundUnitId, 0) > 0) 
			THEN fundunit.FundUnitId
			ELSE ISNULL(pbf.FundId, ISNULL(pbf2.FundId, f.FundUnitId)) 						
		END																											as FundId,
		
		CASE 
		WHEN (ISNULL(fundunit.FundUnitId, 0) > 0)
			THEN  fundunit.UnitLongName
			ELSE CASE 
					WHEN (ISNULL(fund.FundId, 0) > 0)
					THEN fund.Name
					ELSE  ISNULL(pbf.FundName, ISNULL(pbf2.FundName, f.UnknownFundName))
				 END			
		END																											as FundName,	
		ISNULL(ISNULL(pbf.TotalValue, pbf2.TotalValue), pbf3.TotalValue)											as CurrentValue, 
		f.PercentageAllocation																						as PercentageHolding,
		ISNULL(ISNULL(pbf.Cost, pbf2.Cost),pbf3.Cost)																as Cost		
	
	FROM #Funds f
	LEFT JOIN fund2..TFund fund ON fund.FundId = f.FundId
	LEFT JOIN fund2..TFundUnit fundunit ON fundunit.FundUnitId = f.FundUnitId
	LEFT JOIN policymanagement..VPolicyBusinessFundDTO pbf ON pbf.PolicyBusinessId = f.PolicyBusinessId AND pbf.PolicyBusinessFundId = f.PolicyBusinessFundId
	LEFT JOIN policymanagement..VPolicyBusinessFundDTO pbf2 ON pbf.PolicyBusinessId = f.PolicyBusinessId AND pbf2.FundId = f.AssetFundId AND pbf2.HoldingType ='Asset'
	LEFT JOIN policymanagement..VPolicyBusinessFundDTO pbf3 ON pbf3.PolicyBusinessId = f.PolicyBusinessId AND pbf3.FundId = f.FundUnitId AND f.AddManualFundIfFundUnknown = 1
			
END

