SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEvalueGoal]
	@StampUser varchar (255),
	@EvalueGoalId bigint,
	@StampAction char(1)
AS

INSERT INTO TEvalueGoalAudit 
( EvalueLogId, GoalType, GoalId, GoalXml, 
		ConcurrencyId, 
	EvalueGoalId, StampAction, StampDateTime, StampUser) 
Select EvalueLogId, GoalType, GoalId, GoalXml, 
		ConcurrencyId, 
	EvalueGoalId, @StampAction, GetDate(), @StampUser
FROM TEvalueGoal
WHERE EvalueGoalId = @EvalueGoalId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
