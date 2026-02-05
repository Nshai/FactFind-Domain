SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditQuoteClient]
	@StampUser varchar (255),
	@QuoteClientId bigint,
	@StampAction char(1)
AS

INSERT INTO TQuoteClientAudit 
( ClientPartyId, RefOccupationId, TaxRate, EmployerName, 
		TenantId, ConcurrencyId, 
	QuoteClientId, StampAction, StampDateTime, StampUser) 
Select ClientPartyId, RefOccupationId, TaxRate, EmployerName, 
		TenantId, ConcurrencyId, 
	QuoteClientId, @StampAction, GetDate(), @StampUser
FROM TQuoteClient
WHERE QuoteClientId = @QuoteClientId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
