SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveQuoteItemsByPortalQuoteRef] @PortalQuoteRef varchar(50)
AS


SELECT A.QuoteItemId,A.QuoteId,A.PortalQuoteRef,A.QuoteDetailId,
	   B.RefQuoteStatusId,B.MessageDateTime,B.CRMContactId1,B.CRMContactId2,
	   ISNULL(B.PolicyBusinessId,0),B.NumberofQuoteRequests,B.NumberofQuoteResponses,
	   B.IndigoClientId,B.SequentialRef,B.LoggedOnUserId,ISNULL(A.ProviderCodeName,'')'ProviderCodeName',
		ISNULL(B.Guid,'')'Guid'
	
FROM TQuoteItem  A
JOIN TQuote B ON A.QuoteId=B.QuoteId
WHERE A.PortalQuoteRef=@PortalQuoteRef
ORDER BY A.QuoteItemId 

GO
