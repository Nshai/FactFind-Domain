SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditXMLSent]
	@StampUser varchar (255),
	@XMLSentId bigint,
	@StampAction char(1)
AS

INSERT INTO TXMLSentAudit 
( QuoteId, QuoteItemId, RefXMLMessageTypeId, XMLSentData, 
		SentDate, IsLatest, UserId, ConcurrencyId, 
		
	XMLSentId, StampAction, StampDateTime, StampUser) 
Select QuoteId, QuoteItemId, RefXMLMessageTypeId, XMLSentData, 
		SentDate, IsLatest, UserId, ConcurrencyId, 
		
	XMLSentId, @StampAction, GetDate(), @StampUser
FROM TXMLSent
WHERE XMLSentId = @XMLSentId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
