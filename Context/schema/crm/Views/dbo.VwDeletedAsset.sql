SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedAsset]
AS
  SELECT 
    AssetId, 
    'AuditId' = MAX(AuditId)
  FROM TAssetAudit
  WHERE StampAction = 'D'
  GROUP BY AssetId


GO
