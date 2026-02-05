SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateQuoteDetailAsId]
	@StampUser varchar (255), 
	@QuoteId bigint = Null, 
	@XMLSentId bigint = Null, 
	@SumAssuredAmount money = Null, 
	@PremiumAmount money = Null, 
	@CoverBasis varchar (50) = Null, 
	@NumberofQuoteRequests int = Null, 
	@NumberofQuoteResponses int = Null, 
	@TransactionId varchar (255) = Null, 
	@AdviceProcessId varchar (255) = Null, 
	@PortalTransactionId varchar (255) = Null, 
	@PollingStartTime datetime = Null, 
	@ExpiryDate datetime = Null, 
	@RefQuoteStatusId bigint = Null, 
	@RequoteProductDetails varchar (1000) = Null, 
	@OriginalQuoteDetailId bigint = Null, 
	@ConcurrencyId int = 1
AS

Declare @QuoteDetailId Bigint

Insert Into dbo.TQuoteDetail
(QuoteId, XMLSentId, SumAssuredAmount, PremiumAmount, CoverBasis, NumberofQuoteRequests, NumberofQuoteResponses, TransactionId, AdviceProcessId, PortalTransactionId, PollingStartTime, ExpiryDate, RefQuoteStatusId, RequoteProductDetails, OriginalQuoteDetailId, ConcurrencyId)
Values(@QuoteId, @XMLSentId, @SumAssuredAmount, @PremiumAmount, @CoverBasis, @NumberofQuoteRequests, @NumberofQuoteResponses, @TransactionId, @AdviceProcessId, @PortalTransactionId, @PollingStartTime, @ExpiryDate, @RefQuoteStatusId, @RequoteProductDetails, @OriginalQuoteDetailId, @ConcurrencyId)

Select @QuoteDetailId = SCOPE_IDENTITY()
Insert Into dbo.TQuoteDetailAudit
(QuoteDetailId, QuoteId, XMLSentId, SumAssuredAmount, PremiumAmount, CoverBasis, 
NumberofQuoteRequests, NumberofQuoteResponses, TransactionId, AdviceProcessId, PortalTransactionId, PollingStartTime, 
ExpiryDate, RefQuoteStatusId, RequoteProductDetails, OriginalQuoteDetailId, ConcurrencyId, StampAction, StampDateTime, StampUser)
Select [QuoteDetail].QuoteDetailId, [QuoteDetail].QuoteId, [QuoteDetail].XMLSentId, [QuoteDetail].SumAssuredAmount, [QuoteDetail].PremiumAmount, [QuoteDetail].CoverBasis, 
[QuoteDetail].NumberofQuoteRequests, [QuoteDetail].NumberofQuoteResponses, [QuoteDetail].TransactionId, [QuoteDetail].AdviceProcessId, [QuoteDetail].PortalTransactionId, [QuoteDetail].PollingStartTime, 
[QuoteDetail].ExpiryDate, [QuoteDetail].RefQuoteStatusId, [QuoteDetail].RequoteProductDetails, [QuoteDetail].OriginalQuoteDetailId, [QuoteDetail].ConcurrencyId, 'C', getdate(), @StampUser
From TQuoteDetail [QuoteDetail]
Where QuoteDetailId = @QuoteDetailId

Select @QuoteDetailId
GO
