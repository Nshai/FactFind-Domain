SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditOutlookExtensionUserOption]
	@StampUser varchar (255),
	@OutlookExtensionUserOptionId bigint,
	@StampAction char(1)
AS

INSERT INTO TOutlookExtensionUserOptionAudit 
( 	
	UserId,SyncDiaryAppointments,IsSetupNotificationSent,
	ConcurrencyId,OutlookExtensionUserOptionId,StampAction,StampDateTime, StampUser) 
Select 	
	UserId,SyncDiaryAppointments,IsSetupNotificationSent,
	ConcurrencyId,OutlookExtensionUserOptionId,@StampAction, GetDate(), @StampUser
FROM TOutlookExtensionUserOption
WHERE OutlookExtensionUserOptionId = @OutlookExtensionUserOptionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO