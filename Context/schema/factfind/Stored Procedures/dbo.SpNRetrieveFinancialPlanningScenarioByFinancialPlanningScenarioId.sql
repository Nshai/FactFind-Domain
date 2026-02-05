SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveFinancialPlanningScenarioByFinancialPlanningScenarioId]
	@FinancialPlanningScenarioId bigint
AS

SELECT T1.FinancialPlanningScenarioId, T1.FinancialPlanningId, T1.Scenario, ScenarioName,T1.RetirementAge, T1.InitialLumpSum, T1.MonthlyContribution, T1.AnnualWithdrawal, T1.AnnualWithdrawalIncrease,
	T1.RiskProfile, T1.AtrPortfolioGUID, T1.PODGuid, T1.EvalueXML, T1.PrefferedScenario, T1.Active, 
RebalanceInvestments,
RefTaxWrapperId,
AnnualWithdrawalPercent,
StartDate,
TargetDate,
IsReadOnly,
T1.ConcurrencyId
FROM TFinancialPlanningScenario  T1
WHERE T1.FinancialPlanningScenarioId = @FinancialPlanningScenarioId
order by T1.FinancialPlanningScenarioId

GO
