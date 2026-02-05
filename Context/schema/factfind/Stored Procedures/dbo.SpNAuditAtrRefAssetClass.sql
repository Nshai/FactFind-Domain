SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrRefAssetClass]
	@StampUser varchar (255),
	@AtrRefAssetClassId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrRefAssetClassAudit 
( Identifier, Ordering, ConcurrencyId, 
	AtrRefAssetClassId, StampAction, StampDateTime, StampUser) 
Select Identifier, Ordering, ConcurrencyId, 
	AtrRefAssetClassId, @StampAction, GetDate(), @StampUser
FROM TAtrRefAssetClass
WHERE AtrRefAssetClassId = @AtrRefAssetClassId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
