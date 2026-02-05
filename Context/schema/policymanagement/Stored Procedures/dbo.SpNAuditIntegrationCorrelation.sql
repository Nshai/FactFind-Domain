SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditIntegrationCorrelation]
	@StampUser varchar (255),
	@IntegrationCorrelationId bigint,
	@StampAction char(1)
AS

INSERT INTO 
	TIntegrationCorrelationAudit
	(
	CorrelationId, 
	EntityId, 
	EntityType, 
	PortalId, 
	TenantId, 
	IntegrationCorrelationId, 
	StampAction, 
	StampDateTime, 
	StampUser
	)
SELECT  
	CorrelationId, 
	EntityId, 
	EntityType, 
	PortalId, 
	TenantId, 
	IntegrationCorrelationId, 
	@StampAction, 
	GetDate(), 
	@StampUser
FROM 
	TIntegrationCorrelation
WHERE 
	IntegrationCorrelationId = @IntegrationCorrelationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
