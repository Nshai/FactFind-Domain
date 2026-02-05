SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateXMLResponse]
	@StampUser varchar (255),
	@QuoteId bigint, 
	@RefXMLMessageTypeId bigint, 
	@XMLResponseData text = NULL, 
	@ResponseDate datetime, 
	@IsLatest bit	
AS


DECLARE @XMLResponseId bigint, @Result int
			
	
INSERT INTO TXMLResponse
(QuoteId, RefXMLMessageTypeId, XMLResponseData, ResponseDate, IsLatest, ConcurrencyId)
VALUES(@QuoteId, @RefXMLMessageTypeId, @XMLResponseData, @ResponseDate, @IsLatest, 1)

SELECT @XMLResponseId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh

Execute @Result = dbo.SpNAuditXMLResponse @StampUser, @XMLResponseId, 'C'

IF @Result  != 0 GOTO errh

Execute dbo.SpNRetrieveXMLResponseByXMLResponseId @XMLResponseId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
