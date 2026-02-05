SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateEvalueUserReturnId]
	@StampUser varchar (255),
	@EvalueLogId bigint, 
	@UserXml xml 	
AS


DECLARE @EvalueUserId bigint, @Result int
			
	
INSERT INTO TEvalueUser
(EvalueLogId, UserXml, ConcurrencyId)
VALUES(@EvalueLogId, @UserXml, 1)

SELECT @EvalueUserId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditEvalueUser @StampUser, @EvalueUserId, 'C'

IF @Result  != 0 GOTO errh

RETURN (0)

select @EvalueUserId

errh:
RETURN (100)
GO
