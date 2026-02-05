SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateQuoteSummaryAndStatus]
	@QuoteId bigint,
	@RefQuoteStatusId bigint,
	@SummaryXml varchar(1000)=NULL,
	@QuoteRequests int,
	@QuoteResponses int,
	@StampUser bigint
AS

-- TQuote
Insert Into dbo.TQuoteAudit
( RefApplicationId, RefProductTypeId, RefQuoteStatusId, MessageDateTime, AccountUserId,LoggedOnUserId, CRMContactId1, 
	CRMContactId2, PolicyBusinessId, NumberofQuoteRequests, NumberofQuoteResponses, DataXML, SummaryXML, IndigoClientId, SequentialRef,Guid, ConcurrencyId, 
	QuoteId, StampAction, StampDateTime, StampUser )
Select RefApplicationId, RefProductTypeId, RefQuoteStatusId, MessageDateTime, AccountUserId, LoggedOnUserId, CRMContactId1, 
	CRMContactId2, PolicyBusinessId, NumberofQuoteRequests, NumberofQuoteResponses, DataXML, SummaryXML, IndigoClientId, SequentialRef,Guid, ConcurrencyId, 
	QuoteId, 'D', GetDate(), @StampUser 
From  dbo.TQuote 
Where QuoteId = @QuoteId

Update TQuote
SET RefQuoteStatusId=@RefQuoteStatusId,SummaryXml=@SummaryXml,NumberofQuoteRequests=@QuoteRequests,
NumberofQuoteResponses=@QuoteResponses,ConcurrencyId=ConcurrencyId + 1
WHERE QuoteId=@QuoteId
GO
