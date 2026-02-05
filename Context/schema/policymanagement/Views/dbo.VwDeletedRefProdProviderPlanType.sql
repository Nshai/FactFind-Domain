SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefProdProviderPlanType]
AS
  SELECT 
    RefProdProviderPlanTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefProdProviderPlanTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefProdProviderPlanTypeId


GO
