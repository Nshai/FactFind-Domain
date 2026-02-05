SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveOriginalQuoteDetailByQuoteId]
@QuoteId bigint
AS

Select * 
From dbo.TQuoteDetail
Where QuoteId = @QuoteId
And OriginalQuoteDetailId Is Null
GO
