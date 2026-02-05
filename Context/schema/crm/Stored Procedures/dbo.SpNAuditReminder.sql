SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditReminder]
	@StampUser varchar (255),
	@ReminderId bigint,
	@StampAction char(1)
AS

INSERT INTO TReminderAudit 
( ReminderDate, EmailNotificationFg, IndClientId, ReminderHours, 
		ReminderMinutes, ConcurrencyId, 
	ReminderId, StampAction, StampDateTime, StampUser) 
Select ReminderDate, EmailNotificationFg, IndClientId, ReminderHours, 
		ReminderMinutes, ConcurrencyId, 
	ReminderId, @StampAction, GetDate(), @StampUser
FROM TReminder
WHERE ReminderId = @ReminderId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
