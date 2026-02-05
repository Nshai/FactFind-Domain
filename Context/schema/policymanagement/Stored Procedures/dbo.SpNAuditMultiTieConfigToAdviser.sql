SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditMultiTieConfigToAdviser]
	@MultiTieConfigToAdviserId bigint,
	@StampUser varchar (255),
	@StampAction char(1)
AS

INSERT INTO TMultiTieConfigToAdviserAudit 
( MultiTieConfigToAdviserId, MultiTieConfigId, AdviserId, TenantId, ConcurrencyId, StampAction, StampDateTime, StampUser) 
Select MultiTieConfigToAdviserId, MultiTieConfigId, AdviserId, TenantId, ConcurrencyId, @StampAction, GetDate(), @StampUser
FROM TMultiTieConfigToAdviser
WHERE MultiTieConfigToAdviserId = @MultiTieConfigToAdviserId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
