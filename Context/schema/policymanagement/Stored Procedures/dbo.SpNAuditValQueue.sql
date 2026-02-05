SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValQueue]
	@StampUser varchar (255),
	@ValQueueId bigint,
	@StampAction char(1)
AS

INSERT INTO TValQueueAudit 
( Guid, PolicyBusinessId, Status, ValRequestId, 
		StartTime, EndTime, ConcurrencyId, 
	ValQueueId, StampAction, StampDateTime, StampUser) 
Select Guid, PolicyBusinessId, Status, ValRequestId, 
		StartTime, EndTime, ConcurrencyId, 
	ValQueueId, @StampAction, GetDate(), @StampUser
FROM TValQueue
WHERE ValQueueId = @ValQueueId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
