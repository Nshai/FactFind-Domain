SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditUserEmailConfig]
	@StampUser varchar (255),
	@UserEmailConfigId bigint,
	@StampAction char(1)
AS

INSERT INTO TUserEmailConfigAudit 
( RefEmailMatchingConfigId, RefEmailStorageConfigId, RefEmailAttachmentConfigId, UserId, 
		IsActive, Guid, ConcurrencyId, 
	UserEmailConfigId, StampAction, StampDateTime, StampUser) 
Select RefEmailMatchingConfigId, RefEmailStorageConfigId, RefEmailAttachmentConfigId, UserId, 
		IsActive, Guid, ConcurrencyId, 
	UserEmailConfigId, @StampAction, GetDate(), @StampUser
FROM TUserEmailConfig
WHERE UserEmailConfigId = @UserEmailConfigId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
