SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEvalueLog]
	@StampUser varchar (255),
	@EvalueLogId bigint,
	@StampAction char(1)
AS

INSERT INTO TEvalueLogAudit 
( UserName, UserPassword, DateRan, ModellingStatus, 
		RefEvalueLogStatusId, ConcurrencyId, 
	EvalueLogId, StampAction, StampDateTime, StampUser) 
Select UserName, UserPassword, DateRan, ModellingStatus, 
		RefEvalueLogStatusId, ConcurrencyId, 
	EvalueLogId, @StampAction, GetDate(), @StampUser
FROM TEvalueLog
WHERE EvalueLogId = @EvalueLogId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
