SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditResources]
	@StampUser varchar (255),
	@ResourcesId bigint,
	@StampAction char(1)
AS

INSERT INTO TResourcesAudit 
( AppointmentId, ResourceListId, ConcurrencyId, 
	ResourcesId, StampAction, StampDateTime, StampUser) 
Select AppointmentId, ResourceListId, ConcurrencyId, 
	ResourcesId, @StampAction, GetDate(), @StampUser
FROM TResources
WHERE ResourcesId = @ResourcesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
