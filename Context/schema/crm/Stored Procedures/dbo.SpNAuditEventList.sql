SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEventList]
	@StampUser varchar (255),
	@EventListId bigint,
	@StampAction char(1)
AS

INSERT INTO TEventListAudit 
( Name, EventListTemplateId, OwnerUserId, StartDate, 
		ClientCRMContactId, JointClientCRMContactId, PlanId,AdviceCaseId, IndigoClientId, ConcurrencyId, 
		
	EventListId, StampAction, StampDateTime, StampUser) 
Select Name, EventListTemplateId, OwnerUserId, StartDate, 
		ClientCRMContactId, JointClientCRMContactId, PlanId,AdviceCaseId, IndigoClientId, ConcurrencyId, 
		
	EventListId, @StampAction, GetDate(), @StampUser
FROM TEventList
WHERE EventListId = @EventListId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
