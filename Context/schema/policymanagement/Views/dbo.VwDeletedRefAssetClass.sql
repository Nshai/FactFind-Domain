SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefAssetClass]
AS
  SELECT 
    RefAssetClassId, 
    'AuditId' = MAX(AuditId)
  FROM TRefAssetClassAudit
  WHERE StampAction = 'D'
  GROUP BY RefAssetClassId


GO
