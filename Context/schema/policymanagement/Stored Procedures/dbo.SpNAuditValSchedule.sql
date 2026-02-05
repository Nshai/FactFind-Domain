SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValSchedule]
	@StampUser varchar (255),
	@ValScheduleId bigint,
	@StampAction char(1)
AS

INSERT INTO TValScheduleAudit 
( Guid, ScheduledLevel, IndigoClientId, RefProdProviderId, 
		ClientCRMContactId, UserCredentialOption, PortalCRMContactId, StartDate, 
		Frequency, IsLocked, UserNameForFileAccess, PasswordForFileAccess, Password2ForFileAccess,
		ConcurrencyId, 
	ValScheduleId, StampAction, StampDateTime, StampUser) 
Select Guid, ScheduledLevel, IndigoClientId, RefProdProviderId, 
		ClientCRMContactId, UserCredentialOption, PortalCRMContactId, StartDate, 
		Frequency, IsLocked, UserNameForFileAccess, PasswordForFileAccess, Password2ForFileAccess,
		ConcurrencyId, 
	ValScheduleId, @StampAction, GetDate(), @StampUser
FROM TValSchedule
WHERE ValScheduleId = @ValScheduleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
