SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditEvalueResult]
	@StampUser varchar (255),
	@EvalueResultId bigint,
	@StampAction char(1)
AS

INSERT INTO TEvalueResultAudit 
( FinancialPlanningId, EvalueLogId, AxisImageGuid, RefEvalueModellingTypeId, ParentEvalueLogId, ConcurrencyId, 
		
	EvalueResultId, StampAction, StampDateTime, StampUser) 
Select FinancialPlanningId, EvalueLogId, AxisImageGuid, RefEvalueModellingTypeId, ParentEvalueLogId, ConcurrencyId, 
		
	EvalueResultId, @StampAction, GetDate(), @StampUser
FROM TEvalueResult
WHERE EvalueResultId = @EvalueResultId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
