SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEvalueAgreement]
	@StampUser varchar (255),
	@EvalueAgreementId bigint,
	@StampAction char(1)
AS

INSERT INTO TEvalueAgreementAudit 
( EvalueLogId, GoalType, GoalId, ScenarioId, 
		AgreementId, AgreementXml, ConcurrencyId, 
	EvalueAgreementId, StampAction, StampDateTime, StampUser) 
Select EvalueLogId, GoalType, GoalId, ScenarioId, 
		AgreementId, AgreementXml, ConcurrencyId, 
	EvalueAgreementId, @StampAction, GetDate(), @StampUser
FROM TEvalueAgreement
WHERE EvalueAgreementId = @EvalueAgreementId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
