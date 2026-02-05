SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[SpNCustomRetrieveFinancialPlanningSelectedScenario] @FinancialPlanningId int  
  
as  
  

select a.FinancialPlanningScenarioId,  
  a.FinancialPlanningId,  
  a.Scenario,  
  a.ScenarioName,  
  RebalanceInvestments,  
  RefTaxWrapperId,  
  isnull(tw.Description,'') as TaxWrapper,  
  RefTaxWrapperId2,  
  isnull(tw2.Description,'') as TaxWrapper2,  
  a.RetirementAge,  
  a.InitialLumpSum,  
  a.MonthlyContribution,  
  a.AnnualWithdrawal,   
  isnull(AnnualWithdrawalPercent,0) as AnnualWithdrawalPercent,   
  a.AnnualWithdrawalIncrease,  
  a.InitialLumpSum2,  
  a.MonthlyContribution2,  
  a.AnnualWithdrawal2,   
  isnull(AnnualWithdrawalPercent2,0) as AnnualWithdrawalPercent2,   
  a.AnnualWithdrawalIncrease2,  
  a.RiskProfile,  
  a.AtrPortfolioGUID,   
  a.PODGuid,  
  a.EvalueXML,  
  a.PrefferedScenario,  
  a.Active,  
  IsReadOnly,  
  StartDate,  
  TargetDate,  
  RefInvestmentTypeId,  
  a.ConcurrencyId  
from TFinancialPlanningScenario a  
left join TRefFinancialPlanningTaxWrapper tw on a.RefTaxWrapperId = tw.RefFinancialPlanningTaxWrapperId  
left join TRefFinancialPlanningTaxWrapper tw2 on a.RefTaxWrapperId2 = tw2.RefFinancialPlanningTaxWrapperId  
left join TFinancialPlanning fp on fp.financialplanningid = a.financialplanningid  
where a.FinancialPlanningId = @FinancialPlanningId and  
  a.PrefferedScenario = 1  
GO
