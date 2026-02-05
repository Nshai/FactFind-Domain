SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveFinancialPlanningScenarioByFinancialPlanningScenarioId]   
 @FinancialPlanningScenarioId bigint  
AS  
  
SELECT T1.FinancialPlanningScenarioId,   
T1.FinancialPlanningId, T1.Scenario, T1.RetirementAge,   
T1.InitialLumpSum,   
T1.MonthlyContribution,  
 T1.AnnualWithdrawal,  
 T1.AnnualWithdrawalIncrease,   
 T1.RiskProfile,T1.AtrPortfolioGUID, T1.PODGuid, T1.EvalueXML,   
 T1.PrefferedScenario,   
 T1.Active,    
 ScenarioName,  
 RebalanceInvestments,  
 isnull(RefTaxWrapperId,0) as RefTaxWrapperId,  
 isnull(AnnualWithdrawalPercent,0) as AnnualWithdrawalPercent,  
 isnull(StartDate,'') as StartDate,  
 isnull(TargetDate,'') as TargetDate,  
 IsReadOnly,  
 isnull(IsMonthlyModelling,1) as IsMonthlyModelling,  
 T1.ConcurrencyId,  
 T1.InitialLumpSum2,   
T1.MonthlyContribution2,  
 T1.AnnualWithdrawal2,  
 T1.AnnualWithdrawalIncrease2,   
 isnull(RefTaxWrapperId2,0) as RefTaxWrapperId2,  
 isnull(AnnualWithdrawalPercent2,0) as AnnualWithdrawalPercent2  
FROM TFinancialPlanningScenario  T1  
WHERE T1.FinancialPlanningScenarioId = @FinancialPlanningScenarioId  
order by T1.FinancialPlanningScenarioId  
  
GO
