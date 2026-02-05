SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveQuoteWithByQuoteId]
	@QuoteId bigint
AS

Select * 
From PolicyManagement.dbo.TQuote As [Quote]
Inner Join PolicyManagement.dbo.TQuoteItem As [QuoteItem]
	On [Quote].QuoteId = [QuoteItem].QuoteId
Where [Quote].QuoteId = @QuoteId
GO
