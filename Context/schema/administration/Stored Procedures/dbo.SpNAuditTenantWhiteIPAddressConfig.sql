SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditTenantWhiteIPAddressConfig]
	@StampUser varchar (255),
	@TenantWhiteIPAddressConfigId bigint,
	@StampAction char(1)
AS

INSERT INTO TTenantWhiteIPAddressConfigAudit 
( TenantId,IPAddressRangeStart,IPAddressRangeEnd,IsArchievd,ConcurrencyId,TenantWhiteIPAddressConfigId,
StampAction,StampDateTime,StampUser) 
Select TenantId,IPAddressRangeStart,IPAddressRangeEnd,IsArchievd,ConcurrencyId,TenantWhiteIPAddressConfigId,
 @StampAction, GetDate(), @StampUser
FROM TTenantWhiteIPAddressConfig
WHERE TenantWhiteIPAddressConfigId = @TenantWhiteIPAddressConfigId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
