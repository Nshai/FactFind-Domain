SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAppointment]
	@StampUser varchar (255),
	@AppointmentId bigint,
	@StampAction char(1)
AS

INSERT INTO TAppointmentAudit 
( Subject, AddressStoreId, Location, OrganizerCRMContactId, 
		ScratchFG, StartTime, EndTime, AllDayEventFG, 
		ShowTimeAs, Notes, CRMContactId, ReminderId, 
		RefClassificationId, ConcurrencyId, [Guid], Timezone,
		AppointmentId, StampAction, StampDateTime, StampUser,ActivityOutcomeId, CreatedByUserId) 
Select Subject, AddressStoreId, Location, OrganizerCRMContactId, 
		ScratchFG, StartTime, EndTime, AllDayEventFG, 
		ShowTimeAs, Notes, CRMContactId, ReminderId, 
		RefClassificationId, ConcurrencyId, [Guid], Timezone,
		AppointmentId, @StampAction, GetDate(), @StampUser,ActivityOutcomeId, CreatedByUserId
FROM TAppointment
WHERE AppointmentId = @AppointmentId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
