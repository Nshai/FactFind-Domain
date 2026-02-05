SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveQuoteWithQuoteItems] @QuoteId bigint  
AS  
  
  
SELECT A.QuoteItemId,A.QuoteId,A.PortalQuoteRef,A.QuoteDetailId,B.RefProductTypeId,C.ProductTypeName,  
    B.RefQuoteStatusId,B.MessageDateTime,B.CRMContactId1,B.CRMContactId2,  
    ISNULL(B.PolicyBusinessId,0),B.NumberofQuoteRequests,B.NumberofQuoteResponses,  
    B.IndigoClientId,B.SequentialRef,B.LoggedOnUserId,ISNULL(A.ProviderCodeName,'')'ProviderCodeName',  
  ISNULL(B.Guid,'')'Guid'  
   
FROM TQuoteItem  A  
JOIN TQuote B ON A.QuoteId=B.QuoteId 
JOIN TRefProductType C ON B.RefProductTypeId=C.RefProductTypeId
WHERE A.QuoteId=@QuoteId  
AND B.QuoteId=@QuoteId  
ORDER BY A.QuoteItemId

GO
