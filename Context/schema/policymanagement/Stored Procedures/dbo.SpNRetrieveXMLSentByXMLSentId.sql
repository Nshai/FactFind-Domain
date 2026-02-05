SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveXMLSentByXMLSentId]
	@XMLSentId bigint
AS

SELECT T1.XMLSentId, T1.QuoteId, T1.QuoteItemId, T1.RefXMLMessageTypeId, T1.XMLSentData, T1.SentDate, 
	T1.IsLatest, T1.UserId, T1.ConcurrencyId
FROM TXMLSent  T1
WHERE T1.XMLSentId = @XMLSentId
GO
