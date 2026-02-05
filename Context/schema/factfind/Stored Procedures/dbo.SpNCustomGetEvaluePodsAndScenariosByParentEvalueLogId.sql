SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetEvaluePodsAndScenariosByParentEvalueLogId]      
@ParentEvalueLogId Bigint      
      
AS      
      
select       
e.EvalueResultId,      
e.FinancialPlanningId,      
e.EvalueLogId,      
e.RefEvalueModellingTypeId, 
e.ParentEvalueLogId,
d.EvalueXML,       
o.LumpSumAtRetirement,
o.RefLumpsumAtRetirementTypeId,
o.GoalType,

d.PODGuid,      
isnull(s.FinancialPlanningScenarioId,0) as FinancialPlanningScenarioId,      
case when s.Scenario is null then 'Current' else s.Scenario end as Scenario,      
isnull(s.PrefferedScenario,0) as PrefferedScenario,      
ScenarioName,      
isnull(RebalanceInvestments,0) as RebalanceInvestments,      
RefTaxWrapperId,      
isnull(t.Description,'') as TaxWrapper,      
RefTaxWrapperId2,      
isnull(t2.Description,'') as TaxWrapper2,
isnull(IsReadOnly,0) as IsReadOnly,      
RefInvestmentTypeId,
isnull(AverageAnnualReturn,0) as AverageAnnualReturn,
isnull(AverageVolatilityReturn,0) as AverageVolatilityReturn

from dbo.TEvalueResult e      
inner join TEvalueResultDetail d on d.evalueresultid = e.evalueresultid      
left join TFinancialPlanningScenario s on s.FinancialPlanningScenarioId = d.FinancialPlanningScenarioId      
left join TFinancialPlanning fp on fp.FinancialPlanningId = s.FinancialPlanningId      

left join TFinancialPlanningSelectedGoals g on g.FinancialPlanningId = fp.FinancialPlanningId
left join TObjective o on o.ObjectiveId = g.ObjectiveId

left join TRefFinancialPlanningTaxWrapper t on s.RefTaxWrapperId = t.RefFinancialPlanningTaxWrapperId      
left join TRefFinancialPlanningTaxWrapper t2 on s.RefTaxWrapperId2 = t2.RefFinancialPlanningTaxWrapperId      
left join TFinancialPlanningScenarioRiskReturn rr on rr.FinancialPlanningScenarioId = isnull(s.FinancialPlanningScenarioId,0) and rr.financialplanningid = e.financialplanningid


where e.ParentEvalueLogId = @ParentEvalueLogId      
order by s.FinancialPlanningScenarioId      
      
      
      
GO
