SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateEvalueScenarioReturnId]
	@StampUser varchar (255),
	@EvalueLogId bigint, 
	@GoalType varchar(50) , 
	@GoalId bigint, 
	@ScenarioId bigint, 
	@ScenarioXml xml 	
AS


DECLARE @EvalueScenarioId bigint, @Result int
			
	
INSERT INTO TEvalueScenario
(EvalueLogId, GoalType, GoalId, ScenarioId, ScenarioXml, ConcurrencyId)
VALUES(@EvalueLogId, @GoalType, @GoalId, @ScenarioId, @ScenarioXml, 1)

SELECT @EvalueScenarioId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditEvalueScenario @StampUser, @EvalueScenarioId, 'C'

IF @Result  != 0 GOTO errh

select @EvalueScenarioId

RETURN (0)

errh:
RETURN (100)
GO
