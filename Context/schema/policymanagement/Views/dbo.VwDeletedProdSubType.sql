SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedProdSubType]
AS
  SELECT 
    ProdSubTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TProdSubTypeAudit
  WHERE StampAction = 'D'
  GROUP BY ProdSubTypeId


GO
