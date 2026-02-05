SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveCreditNote]
	@CreditNoteId bigint
AS
SELECT
	C.CreditNoteId,
	ISNULL(C.FeeId, 0) AS FeeId,
	ISNULL(C.RetainerId, 0) AS RetainerId,
	C.NetAmount,
	C.VATAmount,
	C.NetAmount + C.VATAmount AS TotalAmount,
	CONVERT(varchar(12), C.DateRaised, 103) AS DateRaised,
	C.SentToClientDate,
	C.[Description],
	C.SequentialRef,
	ISNULL(FVAT.VATRate, RVAT.VATRate) AS VATRate,
	ISNULL(F.SequentialRef, R.SequentialRef) AS RelatedSequentialRef,
	CONVERT(varchar(12), F.InvoiceDate, 103) AS InvoiceDate,
	ISNULL(F.[Description], R.[Description]) AS RelatedDescription
FROM
	TCreditNote C
	LEFT JOIN TFee F ON F.FeeId = C.FeeId
	LEFT JOIN TRetainer R ON R.RetainerId = C.RetainerId
	LEFT JOIN TRefVAT FVAT ON FVAT.RefVATId = F.RefVatId
	LEFT JOIN TRefVAT RVAT ON RVAT.RefVATId = R.RefVatId
WHERE 
	C.CreditNoteId = @CreditNoteId
FOR XML RAW
GO
