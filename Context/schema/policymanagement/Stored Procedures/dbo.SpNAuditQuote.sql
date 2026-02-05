SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditQuote]
	@StampUser varchar (255),
	@QuoteId bigint,
	@StampAction char(1)
AS

INSERT INTO TQuoteAudit 
( RefApplicationId, RefProductTypeId, RefQuoteStatusId, MessageDateTime, 
		QuoteAdviserPartyId, AccountUserId, LoggedOnUserId, QuoteClientId1, QuoteClientTitle1, 
		CRMContactId1, QuoteClientId2, QuoteClientTitle2, CRMContactId2, PolicyBusinessId, 
		NumberofQuoteRequests, NumberofQuoteResponses, DataXML, SummaryXML, 
		IndigoClientId, SequentialRef, Guid,ErrorMessage, ConcurrencyId,
		
	QuoteId, StampAction, StampDateTime, StampUser, QuoteSystemProductType, QuoteInternal,QuoteRequestedAmount) 
Select RefApplicationId, RefProductTypeId, RefQuoteStatusId, MessageDateTime, 
		QuoteAdviserPartyId, AccountUserId, LoggedOnUserId, QuoteClientId1, QuoteClientTitle1, 
		CRMContactId1, QuoteClientId2, QuoteClientTitle2, CRMContactId2, PolicyBusinessId, 
		NumberofQuoteRequests, NumberofQuoteResponses, DataXML, SummaryXML, 
		IndigoClientId, SequentialRef, Guid,ErrorMessage, ConcurrencyId,
		
	QuoteId, @StampAction, GetDate(), @StampUser, QuoteSystemProductType, QuoteInternal,QuoteRequestedAmount
FROM TQuote
WHERE QuoteId = @QuoteId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
