SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveCreditNoteById]
	@CreditNoteId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.CreditNoteId AS [CreditNote!1!CreditNoteId], 
	ISNULL(T1.FeeId, '') AS [CreditNote!1!FeeId], 
	ISNULL(T1.RetainerId, '') AS [CreditNote!1!RetainerId], 
	ISNULL(T1.ProvBreakId, '') AS [CreditNote!1!ProvBreakId], 
	ISNULL(CONVERT(varchar(24), T1.NetAmount), '') AS [CreditNote!1!NetAmount], 
	ISNULL(CONVERT(varchar(24), T1.VATAmount), '') AS [CreditNote!1!VATAmount], 
	ISNULL(CONVERT(varchar(24), T1.DateRaised, 120), '') AS [CreditNote!1!DateRaised], 
	ISNULL(CONVERT(varchar(24), T1.SentToClientDate, 120), '') AS [CreditNote!1!SentToClientDate], 
	ISNULL(T1.Description, '') AS [CreditNote!1!Description], 
	T1.IndigoClientId AS [CreditNote!1!IndigoClientId], 
	T1.ConcurrencyId AS [CreditNote!1!ConcurrencyId],
	ISNULL(T1.SequentialRef, '') AS [CreditNote!1!SequentialRef]
	FROM TCreditNote T1
	
	WHERE T1.CreditNoteId = @CreditNoteId
	ORDER BY [CreditNote!1!CreditNoteId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
