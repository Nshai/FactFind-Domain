SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateEvalueGoalReturnId]
	@StampUser varchar (255),
	@EvalueLogId bigint, 
	@GoalType varchar(50) , 
	@GoalId int, 
	@GoalXml xml 	
AS


DECLARE @EvalueGoalId bigint, @Result int
			
	
INSERT INTO TEvalueGoal
(EvalueLogId, GoalType, GoalId, GoalXml, ConcurrencyId)
VALUES(@EvalueLogId, @GoalType, @GoalId, @GoalXml, 1)

SELECT @EvalueGoalId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditEvalueGoal @StampUser, @EvalueGoalId, 'C'

IF @Result  != 0 GOTO errh

select @EvalueGoalId

RETURN (0)

errh:
RETURN (100)
GO
