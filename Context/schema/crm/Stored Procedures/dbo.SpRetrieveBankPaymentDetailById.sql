SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveBankPaymentDetailById]
@BankPaymentDetailId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.BankPaymentDetailId AS [BankPaymentDetail!1!BankPaymentDetailId], 
    T1.IndClientId AS [BankPaymentDetail!1!IndClientId], 
    T1.BankDetailId AS [BankPaymentDetail!1!BankDetailId], 
    T1.CRMOwnerId AS [BankPaymentDetail!1!CRMOwnerId], 
    T1.RefPaymentTypeId AS [BankPaymentDetail!1!RefPaymentTypeId], 
    T1.PayByChequeFg AS [BankPaymentDetail!1!PayByChequeFg], 
    T1.BlockedFg AS [BankPaymentDetail!1!BlockedFg], 
    T1.ConcurrencyId AS [BankPaymentDetail!1!ConcurrencyId]
  FROM TBankPaymentDetail T1

  WHERE (T1.BankPaymentDetailId = @BankPaymentDetailId)

  ORDER BY [BankPaymentDetail!1!BankPaymentDetailId]

  FOR XML EXPLICIT

END
RETURN (0)









GO
