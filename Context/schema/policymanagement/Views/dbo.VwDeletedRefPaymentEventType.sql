SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefPaymentEventType]
AS
  SELECT 
    RefPaymentEventTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefPaymentEventTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefPaymentEventTypeId


GO
