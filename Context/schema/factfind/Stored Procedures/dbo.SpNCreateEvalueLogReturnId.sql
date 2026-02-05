SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateEvalueLogReturnId]
	@StampUser varchar (255),
	@UserName varchar(50) , 
	@UserPassword varchar(50) , 	
	@ModellingStatus bit = 0,
	@RefEvalueLogStatusId smallint = 1
AS


DECLARE @EvalueLogId bigint, @Result int
			
	
INSERT INTO TEvalueLog
(UserName, UserPassword, DateRan, ModellingStatus, RefEvalueLogStatusId, ConcurrencyId)
VALUES(@UserName, @UserPassword, getdate(), @ModellingStatus,@RefEvalueLogStatusId, 1)

SELECT @EvalueLogId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditEvalueLog @StampUser, @EvalueLogId, 'C'

IF @Result  != 0 GOTO errh


SELECT @EvalueLogId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
