SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditProdSubType]
	@StampUser varchar (255),
	@ProdSubTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TProdSubTypeAudit 
( QuoteProductId, NBProductId, OrigoTableName, ProdSubTypeName, 
		QuoteSubRef, NBSubRef, ClientSummary, ProductSummary, 
		ConcurrencyId, 
	ProdSubTypeId, StampAction, StampDateTime, StampUser) 
Select QuoteProductId, NBProductId, OrigoTableName, ProdSubTypeName, 
		QuoteSubRef, NBSubRef, ClientSummary, ProductSummary, 
		ConcurrencyId, 
	ProdSubTypeId, @StampAction, GetDate(), @StampUser
FROM TProdSubType
WHERE ProdSubTypeId = @ProdSubTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
