SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEventListActivity]
	@StampUser varchar (255),
	@EventListActivityId bigint,
	@StampAction char(1)
AS

INSERT INTO TEventListActivityAudit 
( EventListId, EventListTemplateActivityId, FixedDate, Duration, 
		ElapsedDays, EditElapsedDaysFg, AssignedUserId, AssignedRoleId, 
		StartDate, DeletedFg, CompletedFg, ConcurrencyId, 
		
	EventListActivityId, StampAction, StampDateTime, StampUser) 
Select EventListId, EventListTemplateActivityId, FixedDate, Duration, 
		ElapsedDays, EditElapsedDaysFg, AssignedUserId, AssignedRoleId, 
		StartDate, DeletedFg, CompletedFg, ConcurrencyId, 
		
	EventListActivityId, @StampAction, GetDate(), @StampUser
FROM TEventListActivity
WHERE EventListActivityId = @EventListActivityId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
