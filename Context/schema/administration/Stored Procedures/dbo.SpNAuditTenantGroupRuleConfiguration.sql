SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditTenantGroupRuleConfiguration]
	@StampUser varchar (255),
	@TenantGroupRuleConfigurationId bigint,
	@StampAction char(1)
AS

INSERT INTO TTenantGroupRuleConfigurationAudit 
			(TenantGroupRuleConfigurationId, IsGroupTasksEnabled, IsGroupChargingEnabled, 
			TenantId, ConcurrencyId, StampAction, StampDateTime, StampUser) 

Select TenantGroupRuleConfigurationId, IsGroupTasksEnabled, IsGroupChargingEnabled, TenantId,
	ConcurrencyId, @StampAction, GetDate(), @StampUser
FROM TTenantGroupRuleConfiguration
WHERE TenantGroupRuleConfigurationId = @TenantGroupRuleConfigurationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
