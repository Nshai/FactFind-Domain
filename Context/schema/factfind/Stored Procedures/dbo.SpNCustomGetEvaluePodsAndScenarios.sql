SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetEvaluePodsAndScenarios]      
@EvalueLogId Bigint      
      
AS      
      
select       
e.EvalueResultId,      
e.FinancialPlanningId,      
e.EvalueLogId,      
e.AxisImageGuid,     
e.RefEvalueModellingTypeId, 
e.ParentEvalueLogId,
d.EvalueXML,       
d.PODGuid,      
isnull(s.FinancialPlanningScenarioId,0) as FinancialPlanningScenarioId,      
case when s.Scenario is null then 'Current' else s.Scenario end as Scenario,      
isnull(s.PrefferedScenario,0) as PrefferedScenario,      
isnull(InitialLumpSum,0) as InitialLumpSum,      
isnull(MonthlyContribution,0) as MonthlyContribution,      
isnull(AnnualWithdrawal,0) as AnnualWithdrawal,      
isnull(AnnualWithdrawalPercent,0) as AnnualWithdrawalPercent,      
isnull(InitialLumpSum2,0) as InitialLumpSum2,      
isnull(MonthlyContribution2,0) as MonthlyContribution2,      
isnull(AnnualWithdrawal2,0) as AnnualWithdrawal2,      
isnull(AnnualWithdrawalPercent2,0) as AnnualWithdrawalPercent2,      
RetirementAge,      
case when AnnualWithdrawalIncrease = 'NONE_NONE' then 'None'      
  when AnnualWithdrawalIncrease = 'NONE_0' then '0%'      
  when AnnualWithdrawalIncrease = 'NONE_1' then '1%'      
  when AnnualWithdrawalIncrease = 'NONE_2' then '2%'      
  when AnnualWithdrawalIncrease = 'NONE_3' then '3%'      
  when AnnualWithdrawalIncrease = 'NONE_4' then '4%'      
  when AnnualWithdrawalIncrease = 'NONE_5' then '5%'      
  when AnnualWithdrawalIncrease = 'RPI_0' then 'RPI'      
 end as AnnualWithdrawalIncrease,      
 case when AnnualWithdrawalIncrease2 = 'NONE_NONE' then 'None'      
  when AnnualWithdrawalIncrease2 = 'NONE_0' then '0%'      
  when AnnualWithdrawalIncrease2 = 'NONE_1' then '1%'      
  when AnnualWithdrawalIncrease2 = 'NONE_2' then '2%'      
  when AnnualWithdrawalIncrease2 = 'NONE_3' then '3%'      
  when AnnualWithdrawalIncrease2 = 'NONE_4' then '4%'      
  when AnnualWithdrawalIncrease2 = 'NONE_5' then '5%'      
  when AnnualWithdrawalIncrease2 = 'RPI_0' then 'RPI'      
 end as AnnualWithdrawalIncrease2,      
RiskProfile,      
AtrPortfolioGUID,      
ScenarioName,      
isnull(RebalanceInvestments,0) as RebalanceInvestments,      
RefTaxWrapperId,      
isnull(t.Description,'') as TaxWrapper,      
RefTaxWrapperId2,      
isnull(t2.Description,'') as TaxWrapper2,
StartDate,      
TargetDate,      
isnull(IsReadOnly,0) as IsReadOnly,      
RefInvestmentTypeId,
isnull(AverageAnnualReturn,0) as AverageAnnualReturn,
isnull(AverageVolatilityReturn,0) as AverageVolatilityReturn
from dbo.TEvalueResult e      
inner join TEvalueResultDetail d on d.evalueresultid = e.evalueresultid      
left join TFinancialPlanningScenario s on s.FinancialPlanningScenarioId = d.FinancialPlanningScenarioId      
left join TFinancialPlanning fp on fp.FinancialPlanningId = s.FinancialPlanningId      
left join TRefFinancialPlanningTaxWrapper t on s.RefTaxWrapperId = t.RefFinancialPlanningTaxWrapperId      
left join TRefFinancialPlanningTaxWrapper t2 on s.RefTaxWrapperId2 = t2.RefFinancialPlanningTaxWrapperId      
left join TFinancialPlanningScenarioRiskReturn rr on rr.FinancialPlanningScenarioId = isnull(s.FinancialPlanningScenarioId,0) and rr.financialplanningid = e.financialplanningid
where e.evaluelogid = @EvalueLogId      
order by s.FinancialPlanningScenarioId      
      
      
      
GO
