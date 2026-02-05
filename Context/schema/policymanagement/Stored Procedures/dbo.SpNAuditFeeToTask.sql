SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditFeeToTask]
	@StampUser varchar (255),
	@FeeToTaskId bigint,
	@StampAction char(1)
AS

INSERT INTO TFeeToTaskAudit 
( FeeId, TaskId, TenantId, ConcurrencyId, 
		
	FeeToTaskId, StampAction, StampDateTime, StampUser) 
Select FeeId, TaskId, TenantId, ConcurrencyId, 
		
	FeeToTaskId, @StampAction, GetDate(), @StampUser
FROM TFeeToTask
WHERE FeeToTaskId = @FeeToTaskId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
