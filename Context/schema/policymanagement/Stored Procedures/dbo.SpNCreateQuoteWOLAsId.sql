SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateQuoteWOLAsId]
	@StampUser varchar (255), 
	@QuoteItemId bigint, 
	@CoverBasis varchar (255) = Null, 
	@CoverRequested varchar (255) = Null, 
	@QuotationBasis varchar (255) = Null, 
	@SumAssured decimal (10, 2) = Null, 
	@Premium decimal (10, 2) = Null, 
	@ConcurrencyId int = 1
AS

Declare @QuoteWOLId Bigint

Insert Into dbo.TQuoteWOL
(QuoteItemId, CoverBasis, CoverRequested, QuotationBasis, SumAssured, Premium, ConcurrencyId)
Values(@QuoteItemId, @CoverBasis, @CoverRequested, @QuotationBasis, @SumAssured, @Premium, @ConcurrencyId)

Select @QuoteWOLId = SCOPE_IDENTITY()
Insert Into dbo.TQuoteWOLAudit
(QuoteWOLId, QuoteItemId, CoverBasis, CoverRequested, QuotationBasis, SumAssured, 
Premium, ConcurrencyId, StampAction, StampDateTime, StampUser)
Select [QuoteWOL].QuoteWOLId, [QuoteWOL].QuoteItemId, [QuoteWOL].CoverBasis, [QuoteWOL].CoverRequested, [QuoteWOL].QuotationBasis, [QuoteWOL].SumAssured, 
[QuoteWOL].Premium, [QuoteWOL].ConcurrencyId, 'C', getdate(), @StampUser
From TQuoteWOL [QuoteWOL]
Where QuoteWOLId = @QuoteWOLId

Select @QuoteWOLId
GO
