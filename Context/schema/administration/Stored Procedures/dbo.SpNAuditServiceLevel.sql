SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditServiceLevel]
	@StampUser varchar (255),
	@ServiceLevelId bigint,
	@StampAction char(1)
AS

INSERT INTO TServiceLevelAudit ( 
	Identifier, IndigoClientId, ContractHostFg, UseNetworkAuthorDocs, ConcurrencyId, ServiceLevelId, StampAction, StampDateTime, StampUser) 
SELECT 
	Identifier, IndigoClientId, ContractHostFg, UseNetworkAuthorDocs, ConcurrencyId, ServiceLevelId, @StampAction, GETDATE(), @StampUser
FROM 
	TServiceLevel
WHERE 
	ServiceLevelId = @ServiceLevelId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
