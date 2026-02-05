SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditEventSubscription]
	@StampUser varchar (255),
	@EventSubscriptionId int,
	@StampAction char(1)
AS


INSERT INTO TEventSubscriptionAudit 
( EventSubscriptionId, EntityId,UserId,TenantId,IsPersistent,CreatedDate,EventType,AdditionalContext,CallbackUrl, ConcurrencyId, Metadata, Priority, StampAction, StampDateTime, StampUser) 
Select EventSubscriptionId, EntityId,UserId,TenantId,IsPersistent,CreatedDate,EventType,AdditionalContext,CallbackUrl, ConcurrencyId, Metadata, Priority, @StampAction, GetDate(), @StampUser
FROM TEventSubscription
WHERE EventSubscriptionId = @EventSubscriptionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)