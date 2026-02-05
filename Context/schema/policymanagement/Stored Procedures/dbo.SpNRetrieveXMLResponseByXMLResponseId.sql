SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveXMLResponseByXMLResponseId]
	@XMLResponseId bigint
AS

SELECT T1.XMLResponseId, T1.QuoteId, T1.RefXMLMessageTypeId, T1.XMLResponseData, T1.ResponseDate, T1.IsLatest, T1.ConcurrencyId
FROM TXMLResponse  T1
WHERE T1.XMLResponseId = @XMLResponseId
GO
