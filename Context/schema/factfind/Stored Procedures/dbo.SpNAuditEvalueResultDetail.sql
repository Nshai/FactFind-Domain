SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEvalueResultDetail]
	@StampUser varchar (255),
	@EvalueResultDetailId bigint,
	@StampAction char(1)
AS

INSERT INTO TEvalueResultDetailAudit 
( EvalueResultId, FinancialPlanningScenarioId, EvalueXML, PODGuid, 
		FinalPod, ConcurrencyId, 
	EvalueResultDetailId, StampAction, StampDateTime, StampUser) 
Select EvalueResultId, FinancialPlanningScenarioId, EvalueXML, PODGuid, 
		FinalPod, ConcurrencyId, 
	EvalueResultDetailId, @StampAction, GetDate(), @StampUser
FROM TEvalueResultDetail
WHERE EvalueResultDetailId = @EvalueResultDetailId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
