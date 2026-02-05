SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefProdProvider]
AS
  SELECT 
    RefProdProviderId, 
    'AuditId' = MAX(AuditId)
  FROM TRefProdProviderAudit
  WHERE StampAction = 'D'
  GROUP BY RefProdProviderId

GO
