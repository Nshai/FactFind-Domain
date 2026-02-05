SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedBankDetail]
AS
  SELECT 
    BankDetailId, 
    'AuditId' = MAX(AuditId)
  FROM TBankDetailAudit
  WHERE StampAction = 'D'
  GROUP BY BankDetailId


GO
