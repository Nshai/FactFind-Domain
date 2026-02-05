SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedAssetTypeId]
AS
  SELECT 
    AssetTypeIdId, 
    'AuditId' = MAX(AuditId)
  FROM TAssetTypeIdAudit
  WHERE StampAction = 'D'
  GROUP BY AssetTypeIdId



GO
