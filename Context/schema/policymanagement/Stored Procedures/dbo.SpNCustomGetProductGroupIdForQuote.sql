SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetProductGroupIdForQuote] @QuoteId bigint
AS

Select B.RefProductGroupId
From PolicyManagement..TQuote A
Inner Join PolicyManagement..TRefProductType B ON A.RefProductTypeId=B.RefProductTypeId
Where A.QuoteId = @QuoteId
GO
