SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedAssetType]
AS
  SELECT 
    AssetTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TAssetTypeAudit
  WHERE StampAction = 'D'
  GROUP BY AssetTypeId


GO
