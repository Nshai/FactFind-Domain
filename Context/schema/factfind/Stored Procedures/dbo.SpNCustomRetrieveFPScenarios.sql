SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomRetrieveFPScenarios] @FinancialPlanningId bigint as    
    
select FinancialPlanningScenarioId,    
  FinancialPlanningId,    
  Scenario,    
  ScenarioName,    
  RebalanceInvestments,    
  RefTaxWrapperId,    
  isnull(tw.Description,'') as TaxWrapper,  
  RefTaxWrapperId2,    
  isnull(tw2.Description,'') as TaxWrapper2,    
  RetirementAge,    
  InitialLumpSum,    
  MonthlyContribution,    
  AnnualWithdrawal,    
  isnull(AnnualWithdrawalPercent,0) as AnnualWithdrawalPercent,    
  AnnualWithdrawalIncrease,    
  InitialLumpSum2,    
  MonthlyContribution2,    
  AnnualWithdrawal2,    
  isnull(AnnualWithdrawalPercent2,0) as AnnualWithdrawalPercent2,    
  AnnualWithdrawalIncrease2,    
  StartDate,    
  TargetDate,    
  RiskProfile,    
  AtrPortfolioGUID,    
  PODGuid,    
  EvalueXML,    
  PrefferedScenario,    
  Active,    
  IsReadOnly,    
  IsMonthlyModelling,    
  a.ConcurrencyId    
from TFinancialPlanningScenario a    
left join TRefFinancialPlanningTaxWrapper tw on a.RefTaxWrapperId = tw.RefFinancialPlanningTaxWrapperId    
left join TRefFinancialPlanningTaxWrapper tw2 on a.RefTaxWrapperId2 = tw2.RefFinancialPlanningTaxWrapperId    
where Active = 1 and    
  FinancialPlanningId = @FinancialPlanningId    
order by Scenario    
    
GO
