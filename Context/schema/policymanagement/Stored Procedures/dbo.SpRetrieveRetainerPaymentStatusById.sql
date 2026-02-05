SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRetainerPaymentStatusById]
@RetainerPaymentStatusId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RetainerPaymentStatusId AS [RetainerPaymentStatus!1!RetainerPaymentStatusId], 
    T1.RetainerId AS [RetainerPaymentStatus!1!RetainerId], 
    T1.PaymentStatus AS [RetainerPaymentStatus!1!PaymentStatus], 
    ISNULL(T1.PaymentStatusNotes, '') AS [RetainerPaymentStatus!1!PaymentStatusNotes], 
    CONVERT(varchar(24), T1.PaymentStatusDate, 120) AS [RetainerPaymentStatus!1!PaymentStatusDate], 
    T1.UpdatedUserId AS [RetainerPaymentStatus!1!UpdatedUserId], 
    T1.ConcurrencyId AS [RetainerPaymentStatus!1!ConcurrencyId]
  FROM TRetainerPaymentStatus T1

  WHERE (T1.RetainerPaymentStatusId = @RetainerPaymentStatusId)

  ORDER BY [RetainerPaymentStatus!1!RetainerPaymentStatusId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
