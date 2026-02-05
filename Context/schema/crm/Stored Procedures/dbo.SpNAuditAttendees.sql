SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAttendees]
	@StampUser varchar (255),
	@AttendeesId bigint,
	@StampAction char(1)
AS

INSERT INTO TAttendeesAudit ( 
	AppointmentId, CRMContactId, RefAcceptanceStatusId, OrganiserFG, 
	Name, Email, ConcurrencyId, [BillingRatePerHour],
	AttendeesId, StampAction, StampDateTime, StampUser) 
Select 
	AppointmentId, CRMContactId, RefAcceptanceStatusId, OrganiserFG, 
	Name, Email, ConcurrencyId, [BillingRatePerHour],
	AttendeesId, @StampAction, GetDate(), @StampUser
FROM 
	TAttendees
WHERE 
	AttendeesId = @AttendeesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
