SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditPolicyBusinessIntegration]
	@StampUser varchar (255),
	@PolicyBusinessIntegrationId bigint,
	@StampAction char(1)
AS

INSERT INTO [dbo].[TPolicyBusinessIntegrationAudit]
           ([PolicyBusinessId]
           ,[TenantId]
           ,[Guid]
           ,[PolicyBusinessIntegrationId]
           ,[ConcurrencyId]
           ,[StampAction]
           ,[StampDateTime]
           ,[StampUser])
Select[PolicyBusinessId]
           ,[TenantId]
           ,[Guid]
           ,[PolicyBusinessIntegrationId]
           ,[ConcurrencyId],
		    @StampAction, 
			GetDate(), 
			@StampUser
FROM TPolicyBusinessIntegration
WHERE PolicyBusinessIntegrationId = @PolicyBusinessIntegrationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
