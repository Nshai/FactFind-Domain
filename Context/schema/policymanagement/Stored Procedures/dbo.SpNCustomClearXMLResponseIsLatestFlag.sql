SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomClearXMLResponseIsLatestFlag]  @QuoteId bigint, @RefXMLMessageTypeId bigint, @StampUser bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN

	INSERT INTO TXMLResponseAudit
	(QuoteId, RefXMLMessageTypeId, XMLResponseData, ResponseDate, IsLatest, ConcurrencyId,
	XMLResponseId, StampAction, StampDateTime, StampUser)
	SELECT QuoteId, RefXMLMessageTypeId, XMLResponseData, ResponseDate, IsLatest, ConcurrencyId,
	XMLResponseId, 'U', GetDate(), @StampUser
	FROM TXMLResponse T1
	WHERE QuoteId = @QuoteId And RefXMLMessageTypeId = @RefXMLMessageTypeId
	And T1.IsLatest <> 0
		
	UPDATE T1
	SET T1.IsLatest = 0, T1.ConcurrencyId = T1.ConcurrencyId + 1
	FROM TXMLResponse T1
	WHERE QuoteId = @QuoteId And RefXMLMessageTypeId = @RefXMLMessageTypeId
	And T1.IsLatest <> 0

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
