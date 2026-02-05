SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFeeRecurrence]
	@StampUser varchar (255),
	@FeeRecurrenceId bigint,
	@StampAction char(1)
AS

INSERT INTO TFeeRecurrenceAudit 
(   FeeId, NextExpectationDate,ConcurrencyId,
	FeeRecurrenceId, StampAction, StampDateTime, StampUser) 
Select FeeId, NextExpectationDate,ConcurrencyId,
	   FeeRecurrenceId, @StampAction, GetDate(), @StampUser
FROM TFeeRecurrence
WHERE FeeRecurrenceId = @FeeRecurrenceId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
