SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditQuoteTerm]
	@StampUser varchar (255),
	@QuoteTermId bigint,
	@StampAction char(1)
AS

INSERT INTO TQuoteTermAudit 
( QuoteItemId, PremiumAmount, PremiumType, PremiumIsNet, 
		PremiumFrequency, CoverAmount, TerminalIllness, ConcurrencyId, 
		
	QuoteTermId, StampAction, StampDateTime, StampUser) 
Select QuoteItemId, PremiumAmount, PremiumType, PremiumIsNet, 
		PremiumFrequency, CoverAmount, TerminalIllness, ConcurrencyId, 
		
	QuoteTermId, @StampAction, GetDate(), @StampUser
FROM TQuoteTerm
WHERE QuoteTermId = @QuoteTermId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
