SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefTaxRate]
AS
  SELECT 
    RefTaxRateId, 
    'AuditId' = MAX(AuditId)
  FROM TRefTaxRateAudit
  WHERE StampAction = 'D'
  GROUP BY RefTaxRateId


GO
