SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveQuoteItemByQuoteItemId]
	@QuoteItemId bigint
AS

SELECT T1.QuoteItemId, T1.QuoteId, T1.PortalQuoteRef, T1.KeyXML, T1.ExpiryDate, T1.CommissionAmount, 
	T1.CommissionNote, T1.ProductDescription, T1.IsMarked, T1.CanApply, T1.ProductRef, T1.ProviderCodeName, 
	T1.WarningMessage, T1.QuoteDetailId, T1.ConcurrencyId
FROM TQuoteItem  T1
WHERE T1.QuoteItemId = @QuoteItemId
GO
