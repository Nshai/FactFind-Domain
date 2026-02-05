SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomListPayments]
	@IndigoClientId int,
	@PeriodPayHistId int

AS

BEGIN
 SELECT
  1 AS Tag,
  NULL AS Parent,
  T3.LastName AS [Payment!1!LastName],
  T3.FirstName AS [Payment!1!FirstName],
  T5.SortCode AS [Payment!1!SortCode],
  T5.AccName AS [Payment!1!AccName],
  T5.AccNumber AS [Payment!1!AccNumber],
  T1.Amount AS [Payment!1!Amount]
 FROM Commissions..TPayAdjust T1
 
 INNER JOIN CRM..TCRMContact T3
 ON T3.CRMContactId = T1.CRMContactId
 INNER JOIN CRM..TBankPaymentDetail T4
 ON T4.CRMOwnerId = T1.CRMContactId
 INNER JOIN CRM..TBankDetail T5
 ON T5.BankDetailId = T4.BankDetailId

 WHERE T1.IndClientId = @IndigoClientId
 AND T1.PeriodPayHistId = @PeriodPayHistId

 ORDER BY [Payment!1!LastName]

 FOR XML EXPLICIT

END
RETURN(0)









GO
