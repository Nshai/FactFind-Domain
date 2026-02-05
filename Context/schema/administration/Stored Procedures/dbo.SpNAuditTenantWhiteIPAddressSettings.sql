SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditTenantWhiteIPAddressSettings]
	@StampUser varchar (255),
	@TenantWhiteIpAddressSettingsId bigint,
	@StampAction char(1)
AS

INSERT INTO TTenantWhiteIPAddressSettingsAudit 
( TenantId,ExpireAccessOn,ExpireSettingName,TenantWhiteIpAddressSettingsId,StampAction,StampDateTime,StampUser) 
Select TenantId,ExpireAccessOn,ExpireSettingName,TenantWhiteIpAddressSettingsId, @StampAction, GetDate(), @StampUser
FROM TTenantWhiteIPAddressSettings
WHERE TenantWhiteIpAddressSettingsId = @TenantWhiteIpAddressSettingsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
