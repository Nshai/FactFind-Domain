SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditQuoteDetail]
	@StampUser varchar (255),
	@QuoteDetailId bigint,
	@StampAction char(1)
AS

INSERT INTO TQuoteDetailAudit 
( QuoteId, XMLSentId, SumAssuredAmount, PremiumAmount, 
		CoverBasis, NumberofQuoteRequests, NumberofQuoteResponses, TransactionId, 
		AdviceProcessId, PortalTransactionId, PollingStartTime, ExpiryDate, 
		RefQuoteStatusId, RequoteProductDetails, OriginalQuoteDetailId, ConcurrencyId, 
		
	QuoteDetailId, StampAction, StampDateTime, StampUser, QuoteSystemProductType, QuoteDetailInternal) 
Select QuoteId, XMLSentId, SumAssuredAmount, PremiumAmount, 
		CoverBasis, NumberofQuoteRequests, NumberofQuoteResponses, TransactionId, 
		AdviceProcessId, PortalTransactionId, PollingStartTime, ExpiryDate, 
		RefQuoteStatusId, RequoteProductDetails, OriginalQuoteDetailId, ConcurrencyId, 
		
	QuoteDetailId, @StampAction, GetDate(), @StampUser, QuoteSystemProductType, QuoteDetailInternal
FROM TQuoteDetail
WHERE QuoteDetailId = @QuoteDetailId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
