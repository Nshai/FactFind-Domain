SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomGetSessionOutputs]
@SessionIds varchar(8000)
AS

--Declare @SessionIds varchar(8000) ='3517,3518,3520'

DECLARE @ParsedValues TABLE ( Id INT, ParsedValue VARCHAR(200) )  
INSERT INTO @ParsedValues(Id, ParsedValue)
SELECT Id, Value FROM policymanagement.dbo.FnSplit(@SessionIds, ',')

IF OBJECT_ID('tempdb..#firstGoal') IS NOT NULL
	DROP TABLE #firstGoal

SELECT FinancialPlanningSessionId, MIN(FinancialPlanningGoalId) AS FinancialPlanningGoalId, COUNT(1) as GoalCount
INTO #firstGoal
FROM TFinancialPlanningGoal g WITH(NOLOCK)
INNER JOIN @ParsedValues parslist ON parslist.ParsedValue = g.FinancialPlanningSessionId
GROUP BY g.FinancialPlanningSessionId

SELECT
o.FinancialPlanningOutputId 'FinancialPlanningOutputId', 
s.FinancialPlanningId,
o.FinancialPlanningScenarioId,
o.Name 'OutputName',
ot.Name 'OutputType',
o.Ordinal 'Ordinal',
ts.AtrRefProfilePreferenceId,
CASE WHEN fg.GoalCount > 1 THEN 'Multiple Goals' ELSE g.Objective END AS 'GoalDescription',
obt.Identifier 'GoalType',
g.TargetAmount 'GoalTargetAmount',
wi.DataValue 'WhatIfType',
ta.DataValue 'TargetAmount'

FROM TFinancialPlanningOutput o  WITH(NOLOCK)
INNER JOIN TFinancialPlanningSession s WITH(NOLOCK) on o.FinancialPlanningSessionId = s.FinancialPlanningSessionId
INNER JOIN @ParsedValues parslist on parslist.ParsedValue = s.FinancialPlanningSessionId
INNER JOIN TFinancialPlanningOutputType ot WITH(NOLOCK) on o.FinancialPlanningOutputTypeId = ot.FinancialPlanningOutputTypeId

LEFT JOIN TFinancialPlanningToolsSession ts WITH(NOLOCK) on s.FinancialPlanningId = ts.FinancialPlanningId
LEFT JOIN TFinancialPlanningGoal g WITH(NOLOCK) on s.FinancialPlanningSessionId = g.FinancialPlanningSessionId
LEFT JOIN #firstGoal fg WITH(NOLOCK) on fg.FinancialPlanningSessionId = s.FinancialPlanningSessionId and g.FinancialPlanningGoalId = fg.FinancialPlanningGoalId
LEFT JOIN TObjectiveType obt WITH(NOLOCK) on g.ObjectiveTypeId = obt.ObjectiveTypeId
LEFT JOIN TFinancialPlanningData ta WITH(NOLOCK) on o.FinancialPlanningOutputId = ta.FinancialPlanningOutputId and ta.DataKey = 'Target amount'
LEFT JOIN TFinancialPlanningData wi WITH(NOLOCK) on o.FinancialPlanningOutputId = wi.FinancialPlanningOutputId and wi.DataKey = 'Solution Name'
GO


