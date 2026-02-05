SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateEvalueError]
	@StampUser varchar (255),
	@EvalueLogId bigint, 
	@EvalueErrorDescription varchar (255),
	@EvalueErrorXML xml
AS

declare @Result int
declare @EvalueErrorId int

INSERT INTO TEvalueError
(EvalueLogId,EvalueErrorDescription, EvalueErrorXML,ConcurrencyId)
VALUES(@EvalueLogId, @EvalueErrorDescription, @EvalueErrorXML,1)

SELECT @EvalueErrorId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditEvalueError @StampUser, @EvalueErrorId, 'C'

IF @Result  != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
