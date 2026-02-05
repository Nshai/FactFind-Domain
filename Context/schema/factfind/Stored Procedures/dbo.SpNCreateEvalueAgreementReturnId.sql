SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateEvalueAgreementReturnId]
	@StampUser varchar (255),
	@EvalueLogId bigint, 
	@GoalType varchar(50) , 
	@GoalId bigint, 
	@ScenarioId bigint, 
	@AgreementId bigint,
	@AgreementXml xml	
AS


DECLARE @EvalueAgreementId bigint, @Result int
			
	
INSERT INTO TEvalueAgreement
(EvalueLogId, GoalType, GoalId, ScenarioId, AgreementId, AgreementXml, 
	ConcurrencyId)
VALUES(@EvalueLogId, @GoalType, @GoalId, @ScenarioId, @AgreementId, @AgreementXml, 1)

SELECT @EvalueAgreementId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditEvalueAgreement @StampUser, @EvalueAgreementId, 'C'

IF @Result  != 0 GOTO errh

SELECT @EvalueAgreementId

RETURN (0)

errh:
RETURN (100)
GO
