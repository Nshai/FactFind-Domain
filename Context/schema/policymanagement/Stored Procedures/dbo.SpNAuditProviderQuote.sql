SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditProviderQuote]
	@StampUser varchar (255),
	@ProviderQuoteId bigint,
	@StampAction char(1)
AS

INSERT INTO TProviderQuoteAudit 
( QuoteId, RefProductProviderId, ProviderCode, TenantId, 
		ConcurrencyId, 
	ProviderQuoteId, StampAction, StampDateTime, StampUser) 
Select QuoteId, RefProductProviderId, ProviderCode, TenantId, 
		ConcurrencyId, 
	ProviderQuoteId, @StampAction, GetDate(), @StampUser
FROM TProviderQuote
WHERE ProviderQuoteId = @ProviderQuoteId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
