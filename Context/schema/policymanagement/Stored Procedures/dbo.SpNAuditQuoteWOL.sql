SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditQuoteWOL]
	@StampUser varchar (255),
	@QuoteWOLId bigint,
	@StampAction char(1)
AS

INSERT INTO TQuoteWOLAudit 
( QuoteItemId, CoverBasis, CoverRequested, QuotationBasis, 
		SumAssured, Premium, ConcurrencyId, 
	QuoteWOLId, StampAction, StampDateTime, StampUser) 
Select QuoteItemId, CoverBasis, CoverRequested, QuotationBasis, 
		SumAssured, Premium, ConcurrencyId, 
	QuoteWOLId, @StampAction, GetDate(), @StampUser
FROM TQuoteWOL
WHERE QuoteWOLId = @QuoteWOLId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
