SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditEventListTemplateActivity]
	@StampUser varchar (255),
	@EventListTemplateActivityId bigint,
	@StampAction char(1)
AS

INSERT INTO TEventListTemplateActivityAudit 
( EventListTemplateId, ActivityCategoryId, FixedDateFg, DeletableFg, 
		Duration, ElapsedDays, EditElapsedDaysFg, AssignedUserId, 
		ConcurrencyId, IsRecurring,RFCCode,
	EventListTemplateActivityId, StampAction, StampDateTime, StampUser) 
Select EventListTemplateId, ActivityCategoryId, FixedDateFg, DeletableFg, 
		Duration, ElapsedDays, EditElapsedDaysFg, AssignedUserId, 
		ConcurrencyId,  IsRecurring,RFCCode,
	EventListTemplateActivityId, @StampAction, GetDate(), @StampUser
FROM TEventListTemplateActivity
WHERE EventListTemplateActivityId = @EventListTemplateActivityId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
