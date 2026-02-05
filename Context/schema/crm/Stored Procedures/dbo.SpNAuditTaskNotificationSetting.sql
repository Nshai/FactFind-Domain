SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditTaskNotificationSetting]
	@StampUser varchar (255),
	@TaskNotificationSettingId bigint,
	@StampAction char(1)
AS

INSERT INTO TTaskNotificationSettingAudit 
( [TenantId], [UserId], [NotifyOnAssignment], [TaskNotificationSettingId], [StampAction], [StampDateTime], [StampUser] ) 
Select [TenantId], [UserId], [NotifyOnAssignment], [TaskNotificationSettingId], @StampAction, GetDate(), @StampUser
FROM TTaskNotificationSetting
WHERE TaskNotificationSettingId = @TaskNotificationSettingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO