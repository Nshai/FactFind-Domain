SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpNCustomUpdateEvalueLogModellingStatus
	@EvalueLogId Bigint,	
	@StampUser varchar (255),	
	@ModellingStatus int

AS


Declare @Result int
Execute @Result = dbo.SpNAuditEvalueLog @StampUser, @EvalueLogId, 'U'

IF @Result  != 0 GOTO errh


UPDATE T1
SET		T1.ModellingStatus = @ModellingStatus, 
		T1.ConcurrencyId = T1.ConcurrencyId + 1
FROM TEvalueLog T1
WHERE  T1.EvalueLogId = @EvalueLogId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
