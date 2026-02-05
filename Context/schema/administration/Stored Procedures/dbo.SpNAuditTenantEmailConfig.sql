SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditTenantEmailConfig]
	@StampUser varchar (255),
	@TenantEmailConfigId bigint,
	@StampAction char(1)
AS

INSERT INTO TTenantEmailConfigAudit 
( RefEmailDuplicateConfigId, RefEmailStorageConfigId, RefEmailAttachmentConfigId, TenantId, 
		IsAuthenticateSPF, IsAuthenticateSenderId, IsAuthenticateDomainKey, MaximumEmailSize, 
		ConcurrencyId, 
	TenantEmailConfigId, StampAction, StampDateTime, StampUser) 
Select RefEmailDuplicateConfigId, RefEmailStorageConfigId, RefEmailAttachmentConfigId, TenantId, 
		IsAuthenticateSPF, IsAuthenticateSenderId, IsAuthenticateDomainKey, MaximumEmailSize, 
		ConcurrencyId, 
	TenantEmailConfigId, @StampAction, GetDate(), @StampUser
FROM TTenantEmailConfig
WHERE TenantEmailConfigId = @TenantEmailConfigId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
