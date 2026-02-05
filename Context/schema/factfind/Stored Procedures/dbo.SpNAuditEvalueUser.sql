SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEvalueUser]
	@StampUser varchar (255),
	@EvalueUserId bigint,
	@StampAction char(1)
AS

INSERT INTO TEvalueUserAudit 
( EvalueLogId, UserXml, ConcurrencyId, 
	EvalueUserId, StampAction, StampDateTime, StampUser) 
Select EvalueLogId, UserXml, ConcurrencyId, 
	EvalueUserId, @StampAction, GetDate(), @StampUser
FROM TEvalueUser
WHERE EvalueUserId = @EvalueUserId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
