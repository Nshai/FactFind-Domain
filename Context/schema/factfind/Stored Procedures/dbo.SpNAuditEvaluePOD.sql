SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEvaluePOD]
	@StampUser varchar (255),
	@EvaluePODId bigint,
	@StampAction char(1)
AS

INSERT INTO TEvaluePODAudit 
( EvalueLogId, GoalType, GoalId, ScenarioIds, 
		ParameterXml, ConcurrencyId, 
	EvaluePODId, StampAction, StampDateTime, StampUser) 
Select EvalueLogId, GoalType, GoalId, ScenarioIds, 
		ParameterXml, ConcurrencyId, 
	EvaluePODId, @StampAction, GetDate(), @StampUser
FROM TEvaluePOD
WHERE EvaluePODId = @EvaluePODId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
