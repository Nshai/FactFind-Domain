SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditMultiTie]
	@StampUser varchar (255),
	@MultiTieId bigint,
	@StampAction char(1)
AS

INSERT INTO TMultiTieAudit 
( IndigoClientId, RefProdProviderId, RefPlanType2ProdSubTypeId, ConcurrencyId, 
		
	MultiTieId, MultiTieConfigId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, RefProdProviderId, RefPlanType2ProdSubTypeId, ConcurrencyId, 
		
	MultiTieId, MultiTieConfigId, @StampAction, GetDate(), @StampUser
FROM TMultiTie
WHERE MultiTieId = @MultiTieId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
