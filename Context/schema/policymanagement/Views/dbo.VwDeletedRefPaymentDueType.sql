SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefPaymentDueType]
AS
  SELECT 
    RefPaymentDueTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefPaymentDueTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefPaymentDueTypeId


GO
