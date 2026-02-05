SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateXMLSent]
	@StampUser varchar (255),
	@QuoteId bigint, 
	@QuoteItemId bigint = NULL, 
	@RefXMLMessageTypeId bigint, 
	@XMLSentData text = NULL, 
	@SentDate datetime, 
	@IsLatest bit = 0, 
	@UserId bigint	
AS


DECLARE @XMLSentId bigint, @Result int
			
	
INSERT INTO TXMLSent
(QuoteId, QuoteItemId, RefXMLMessageTypeId, XMLSentData, SentDate, IsLatest, 
	UserId, ConcurrencyId)
VALUES(@QuoteId, @QuoteItemId, @RefXMLMessageTypeId, @XMLSentData, @SentDate, @IsLatest, 
	@UserId, 1)

SELECT @XMLSentId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh

Execute @Result = dbo.SpNAuditXMLSent @StampUser, @XMLSentId, 'C'

IF @Result  != 0 GOTO errh

Execute dbo.SpNRetrieveXMLSentByXMLSentId @XMLSentId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
