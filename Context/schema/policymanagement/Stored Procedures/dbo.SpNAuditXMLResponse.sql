SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditXMLResponse]
	@StampUser varchar (255),
	@XMLResponseId bigint,
	@StampAction char(1)
AS

INSERT INTO TXMLResponseAudit 
( QuoteId, RefXMLMessageTypeId, XMLResponseData, ResponseDate, 
		IsLatest, ConcurrencyId, 
	XMLResponseId, StampAction, StampDateTime, StampUser) 
Select QuoteId, RefXMLMessageTypeId, XMLResponseData, ResponseDate, 
		IsLatest, ConcurrencyId, 
	XMLResponseId, @StampAction, GetDate(), @StampUser
FROM TXMLResponse
WHERE XMLResponseId = @XMLResponseId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
