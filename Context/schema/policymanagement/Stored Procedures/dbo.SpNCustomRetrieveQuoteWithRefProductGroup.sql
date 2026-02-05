SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveQuoteWithRefProductGroup]
	@QuoteId bigint
AS

Select * 
From PolicyManagement.dbo.TQuote As [Quote]
Inner Join PolicyManagement.dbo.TRefProductType As [RefProductType]
	On [Quote].RefProductTypeId = [RefProductType].RefProductTypeId
Inner Join PolicyManagement.dbo.TRefProductGroup As [RefProductGroup]
	On [RefProductType].RefProductGroupId = [RefProductGroup].RefProductGroupId
Where [Quote].QuoteId = @QuoteId
GO
