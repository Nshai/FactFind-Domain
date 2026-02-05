SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateEvaluePodReturnId]
	@StampUser varchar (255),
	@EvalueLogId bigint, 
	@GoalType varchar (50),
	@GoalId int,
	@ScenarioIds varchar (50),
	@ParameterXML xml
AS


DECLARE @EvaluePodId bigint, @Result int
			
	
INSERT INTO TEvaluePod
(EvalueLogId,GoalType,GoalId,ScenarioIds,ParameterXml,ConcurrencyId)
VALUES(@EvalueLogId, @GoalType,@GoalId,@ScenarioIds,@ParameterXML,1)

SELECT @EvaluePodId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditEvaluePod @StampUser, @EvaluePodId, 'C'

IF @Result  != 0 GOTO errh

RETURN (0)

select @EvaluePodId

errh:
RETURN (100)
GO
