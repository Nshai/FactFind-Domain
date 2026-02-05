Create PROCEDURE [dbo].[SpNAuditEventListTemplateHidden]
	@StampUser varchar (255),
	@EventListTemplateHiddenId bigint,
	@StampAction char(1)
AS

INSERT INTO TEventListTemplateHiddenAudit 
( EventListTemplateId, GroupId, TenantId, ConcurrencyId, 
		
	EventListTemplateHiddenId, StampAction, StampDateTime, StampUser) 
Select EventListTemplateId, GroupId, TenantId, ConcurrencyId, 
		
	EventListTemplateHiddenId, @StampAction, GetDate(), @StampUser
FROM TEventListTemplateHidden
WHERE EventListTemplateHiddenId = @EventListTemplateHiddenId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO


