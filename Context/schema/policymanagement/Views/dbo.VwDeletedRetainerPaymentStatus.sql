SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRetainerPaymentStatus]
AS
  SELECT 
    RetainerPaymentStatusId, 
    'AuditId' = MAX(AuditId)
  FROM TRetainerPaymentStatusAudit
  WHERE StampAction = 'D'
  GROUP BY RetainerPaymentStatusId


GO
