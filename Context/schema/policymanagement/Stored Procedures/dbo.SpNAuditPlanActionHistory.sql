SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPlanActionHistory]
	@StampUser varchar (255),
	@PlanActionHistoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TPlanActionHistoryAudit 
( PolicyBusinessId, RefPlanActionId, ChangedFrom, ChangedTo, DateOfChange, 
		ChangedByUserId, ConcurrencyId, 
	PlanActionHistoryId, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessId, RefPlanActionId, ChangedFrom, ChangedTo, DateOfChange, 
		ChangedByUserId, ConcurrencyId, 
	PlanActionHistoryId, @StampAction, GetDate(), @StampUser
FROM TPlanActionHistory
WHERE PlanActionHistoryId = @PlanActionHistoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
