SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefWithdrawalType]
AS
  SELECT 
    RefWithdrawalTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefWithdrawalTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefWithdrawalTypeId


GO
