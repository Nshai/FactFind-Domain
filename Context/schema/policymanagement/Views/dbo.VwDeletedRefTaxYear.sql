SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefTaxYear]
AS
  SELECT 
    RefTaxYearId, 
    'AuditId' = MAX(AuditId)
  FROM TRefTaxYearAudit
  WHERE StampAction = 'D'
  GROUP BY RefTaxYearId




GO
