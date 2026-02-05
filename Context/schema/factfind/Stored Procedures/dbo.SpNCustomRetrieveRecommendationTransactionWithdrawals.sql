SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrieveRecommendationTransactionWithdrawals] 
(
	 @ActionPlanIds VARCHAR(8000),
	 @ManualTransactionIds VARCHAR(8000)
)
AS
BEGIN

IF(OBJECT_ID('tempdb..#ScenarioTIds') IS NOT NULL) DROP TABLE #ScenarioTIds
SELECT DISTINCT Value AS Id INTO #ScenarioTIds FROM policymanagement.dbo.FnSplit(@ActionPlanIds, ',')

IF(OBJECT_ID('tempdb..#ManualTIds') IS NOT NULL) DROP TABLE #ManualTIds
SELECT DISTINCT Value AS Id INTO #ManualTIds FROM policymanagement.dbo.FnSplit(@ManualTransactionIds, ',')


	SELECT 
		DISTINCT
		 cast( fps.FinancialPlanningScenarioId as VARCHAR(100))+'O'		as RecommendationId,
		 cast( ap.ActionPlanId as VARCHAR(255))+'O'						as TransactionId,
		 apw.ActionPlanWithdrawalId										as TransactionWithdawalId, 
		 apw.WithdrawalAmount											as Amount, 
		 apw.WithdrawalFrequency										as WithdrawalFrequency, 
		 apw.WithdrawalType												as WithdrawalType, 
		 fp.FinancialPlanningId											as FinancialPlanningId 
 
	FROM FactFind.dbo.TActionPlanWithdrawal apw WITH(NOLOCK)
	inner join #ScenarioTIds Ids WITH(NOLOCK)   ON apw.ActionPlanId = Ids.Id
	inner join FactFind.dbo.TActionPlan ap WITH(NOLOCK) on apw.ActionPlanId=ap.ActionPlanId 
	inner join FactFind.dbo.TFinancialPlanning fp WITH(NOLOCK) on ap.FinancialPlanningId=fp.FinancialPlanningId 
	inner join FactFind.dbo.TFinancialPlanningScenario fps WITH(NOLOCK) on ap.ScenarioId=fps.FinancialPlanningScenarioId 

	UNION

	SELECT DISTINCT
		CAST(mr.ManualRecommendationId AS VARCHAR(100))+'M'															as RecommendationId,
		CAST(ma.ManualRecommendationActionId AS VARCHAR(100))+'M'													as TransactionId,
		ma.ManualRecommendationActionId 																			as TransactionWithdawalId,
		ma.WithdrawalAmount																							as Amount,
		freq.FrequencyName																						    as WithdrawalFrequency, 
		wtype.WithdrawalName																						as WithdrawalType, 
		fps.FinancialPlanningId																						as FinancialPlanningId

	FROM factfind.dbo.TManualRecommendationAction ma WITH(NOLOCK)
	inner join #ManualTIds Ids ON ma.ManualRecommendationActionId = ids.Id
	inner join FactFind.dbo.TManualRecommendation mr WITH(NOLOCK) ON ma.ManualRecommendationId = mr.ManualRecommendationId	
	inner join FactFind.dbo.TFinancialPlanningSession fps WITH(NOLOCK) ON fps.FinancialPlanningSessionId = mr.FinancialPlanningSessionId 
	inner join PolicyManagement.dbo.TRefWithdrawalType wtype WITH(NOLOCK) ON ma.RefWithdrawalTypeId = wtype.RefWithdrawalTypeId
	inner join PolicyManagement.dbo.TRefFrequency freq WITH(NOLOCK) ON ma.RefWithdrawalFrequencyId = freq.RefFrequencyId
END