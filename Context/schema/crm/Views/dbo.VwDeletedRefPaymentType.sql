SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefPaymentType]
AS
  SELECT 
    RefPaymentTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefPaymentTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefPaymentTypeId


GO
