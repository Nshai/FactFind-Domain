SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveFeePaymentStatusById]
@FeePaymentStatusId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.FeePaymentStatusId AS [FeePaymentStatus!1!FeePaymentStatusId], 
    T1.FeeId AS [FeePaymentStatus!1!FeeId], 
    T1.PaymentStatus AS [FeePaymentStatus!1!PaymentStatus], 
    ISNULL(T1.PaymentStatusNotes, '') AS [FeePaymentStatus!1!PaymentStatusNotes], 
    CONVERT(varchar(24), T1.PaymentStatusDate, 120) AS [FeePaymentStatus!1!PaymentStatusDate], 
    T1.UpdatedUserId AS [FeePaymentStatus!1!UpdatedUserId], 
    T1.ConcurrencyId AS [FeePaymentStatus!1!ConcurrencyId]
  FROM TFeePaymentStatus T1

  WHERE (T1.FeePaymentStatusId = @FeePaymentStatusId)

  ORDER BY [FeePaymentStatus!1!FeePaymentStatusId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
