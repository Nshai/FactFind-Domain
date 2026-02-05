SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedFeePaymentStatus]
AS
  SELECT 
    FeePaymentStatusId, 
    'AuditId' = MAX(AuditId)
  FROM TFeePaymentStatusAudit
  WHERE StampAction = 'D'
  GROUP BY FeePaymentStatusId


GO
