SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedResources]
AS
  SELECT 
    ResourcesId, 
    'AuditId' = MAX(AuditId)
  FROM TResourcesAudit
  WHERE StampAction = 'D'
  GROUP BY ResourcesId

GO
