SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpNAuditTermQuote
      @StampUser varchar (255),
      @TermQuoteId bigint,
      @StampAction char(1)
AS

INSERT INTO TTermQuoteAudit 
	(
	QuoteId,
	ProductTermId,
	QuotationBasisId,
	QuotePremiumId,
	LivesAssuredBasis,
	IncludeRenewable,
	IncludeBusinessProtectionLevel,
	IncludeBusinessProtectionDecreasing,
	MortgageInterestRate,
	PolicyInterestRate,
	PremiumWaiverRequired,
	IncludeTerminalIllness,
	TenantId,		
	ConcurrencyId,
	TermQuoteId,
	StampAction,
	StampDateTime,
	StampUser)
SELECT  
	QuoteId,
	ProductTermId,
	QuotationBasisId,
	QuotePremiumId,
	LivesAssuredBasis,
	IncludeRenewable,
	IncludeBusinessProtectionLevel,
	IncludeBusinessProtectionDecreasing,	
	MortgageInterestRate,
	PolicyInterestRate,	
	PremiumWaiverRequired,
	IncludeTerminalIllness,
	TenantId,		
	ConcurrencyId,
	TermQuoteId,
	@StampAction, 
	GetDate(), 
	@StampUser
FROM TTermQuote
WHERE TermQuoteId = @TermQuoteId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
