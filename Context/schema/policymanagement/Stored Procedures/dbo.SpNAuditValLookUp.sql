SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValLookUp]
	@StampUser varchar (255),
	@ValLookUpId bigint,
	@StampAction char(1)
AS

INSERT INTO TValLookUpAudit 
( RefProdProviderId, MappedRefProdProviderId, ConcurrencyId, 
	ValLookUpId, StampAction, StampDateTime, StampUser) 
Select RefProdProviderId, MappedRefProdProviderId, ConcurrencyId, 
	ValLookUpId, @StampAction, GetDate(), @StampUser
FROM TValLookUp
WHERE ValLookUpId = @ValLookUpId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
