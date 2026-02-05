SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[SpNAuditMultiTieConfig]
	@StampUser varchar (255),
	@MultiTieConfigId bigint,
	@StampAction char(1)
AS

INSERT INTO TMultiTieConfigAudit
(MultiTieConfigId, MultiTieName, TenantId, ConcurrencyId,IsArchived,
	StampAction, StampDateTime, StampUser)
SELECT MultiTieConfigId, MultiTieName, TenantId, ConcurrencyId,IsArchived,
	@StampAction, GetDate(), @StampUser
FROM TMultiTieConfig
WHERE MultiTieConfigId = @MultiTieConfigId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
