SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEntityOrganiserActivity]
	@StampUser varchar (255),
	@EntityOrganiserActivityId bigint,
	@StampAction char(1)
AS

INSERT INTO TEntityOrganiserActivityAudit 
( ActivityEntityTypeId, EntityId, OrganiserActivityId, ConcurrencyId, 
		
	EntityOrganiserActivityId, StampAction, StampDateTime, StampUser) 
Select ActivityEntityTypeId, EntityId, OrganiserActivityId, ConcurrencyId, 
		
	EntityOrganiserActivityId, @StampAction, GetDate(), @StampUser
FROM TEntityOrganiserActivity
WHERE EntityOrganiserActivityId = @EntityOrganiserActivityId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
