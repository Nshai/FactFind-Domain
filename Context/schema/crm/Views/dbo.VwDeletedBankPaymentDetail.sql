SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedBankPaymentDetail]
AS
  SELECT 
    BankPaymentDetailId, 
    'AuditId' = MAX(AuditId)
  FROM TBankPaymentDetailAudit
  WHERE StampAction = 'D'
  GROUP BY BankPaymentDetailId


GO
