SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditStatusHistory]
	@StampUser varchar (255),
	@StatusHistoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TStatusHistoryAudit 
( PolicyBusinessId, StatusId, StatusReasonId, ChangedToDate, 
		ChangedByUserId, DateOfChange, LifeCycleStepFG, CurrentStatusFG, 
		ConcurrencyId, 
	StatusHistoryId, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessId, StatusId, StatusReasonId, ChangedToDate, 
		ChangedByUserId, DateOfChange, LifeCycleStepFG, CurrentStatusFG, 
		ConcurrencyId, 
	StatusHistoryId, @StampAction, GetDate(), @StampUser
FROM TStatusHistory
WHERE StatusHistoryId = @StatusHistoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
