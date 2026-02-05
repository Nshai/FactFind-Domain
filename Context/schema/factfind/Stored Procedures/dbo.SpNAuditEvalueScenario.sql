SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEvalueScenario]
	@StampUser varchar (255),
	@EvalueScenarioId bigint,
	@StampAction char(1)
AS

INSERT INTO TEvalueScenarioAudit 
( EvalueLogId, GoalType, GoalId, ScenarioId, 
		ScenarioXml, ConcurrencyId, 
	EvalueScenarioId, StampAction, StampDateTime, StampUser) 
Select EvalueLogId, GoalType, GoalId, ScenarioId, 
		ScenarioXml, ConcurrencyId, 
	EvalueScenarioId, @StampAction, GetDate(), @StampUser
FROM TEvalueScenario
WHERE EvalueScenarioId = @EvalueScenarioId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
