SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEvalueError]
	@StampUser varchar (255),
	@EvalueErrorId bigint,
	@StampAction char(1)
AS

INSERT INTO TEvalueErrorAudit 
( EvalueLogId, EvalueErrorDescription, EvalueErrorXML, ConcurrencyId, 
		
	EvalueErrorId, StampAction, StampDateTime, StampUser) 
Select EvalueLogId, EvalueErrorDescription, EvalueErrorXML, ConcurrencyId, 
		
	EvalueErrorId, @StampAction, GetDate(), @StampUser
FROM TEvalueError
WHERE EvalueErrorId = @EvalueErrorId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
