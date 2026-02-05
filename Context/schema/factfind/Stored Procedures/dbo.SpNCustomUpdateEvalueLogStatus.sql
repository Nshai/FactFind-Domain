SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.[SpNCustomUpdateEvalueLogStatus]	
	@StampUser varchar (255),
	@UserName varchar (255),
	@UserPassword varchar (255),
	@OldRefEvalueLogStatusId smallint,
	@NewRefEvalueLogStatusId smallint
AS

Declare @Result int
Declare @EvalueLogId bigint

--get the evalue log id
select	@EvalueLogId = EvalueLogId from	TEvalueLog where UserName = @UserName and UserPassword = @UserPassword and RefEvalueLogStatusId = @OldRefEvalueLogStatusId

Execute @Result = dbo.SpNAuditEvalueLog @StampUser, @EvalueLogId, 'U'

IF @Result  != 0 GOTO errh

UPDATE T1
SET		T1.RefEvalueLogStatusId = @NewRefEvalueLogStatusId,
		T1.ConcurrencyId = T1.ConcurrencyId + 1
FROM TEvalueLog T1
WHERE  T1.EvalueLogId = @EvalueLogId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
