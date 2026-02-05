SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditQuoteItem]
	@StampUser varchar (255),
	@QuoteItemId bigint,
	@StampAction char(1)
AS

INSERT INTO TQuoteItemAudit 
( QuoteId, PortalQuoteRef, KeyXML, ExpiryDate, 
		CommissionAmount, CommissionNote, ProductDescription, IsMarked, 
		CanApply, ProductRef, ProviderCodeName, WarningMessage, 
		QuoteDetailId, ConcurrencyId, PolicyBusinessId,
		QuoteItemId, StampAction, StampDateTime, StampUser) 
Select QuoteId, PortalQuoteRef, KeyXML, ExpiryDate, 
		CommissionAmount, CommissionNote, ProductDescription, IsMarked, 
		CanApply, ProductRef, ProviderCodeName, WarningMessage, 
		QuoteDetailId, ConcurrencyId, PolicyBusinessId,		
	QuoteItemId, @StampAction, GetDate(), @StampUser
FROM TQuoteItem
WHERE QuoteItemId = @QuoteItemId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
