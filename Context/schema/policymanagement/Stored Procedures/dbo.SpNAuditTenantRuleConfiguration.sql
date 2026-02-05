SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditTenantRuleConfiguration]
	@StampUser varchar (255),
	@TenantRuleConfigurationId bigint,
	@StampAction char(1)
AS

INSERT INTO TTenantRuleConfigurationAudit 
( RefRuleConfigurationId, IsConfigured, TenantId, ConcurrencyId, 
		
	TenantRuleConfigurationId, StampAction, StampDateTime, StampUser) 
Select RefRuleConfigurationId, IsConfigured, TenantId, ConcurrencyId, 
		
	TenantRuleConfigurationId, @StampAction, GetDate(), @StampUser
FROM TTenantRuleConfiguration
WHERE TenantRuleConfigurationId = @TenantRuleConfigurationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
