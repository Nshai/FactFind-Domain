SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedResourceManager]
AS
  SELECT 
    ResourceManagerId, 
    'AuditId' = MAX(AuditId)
  FROM TResourceManagerAudit
  WHERE StampAction = 'D'
  GROUP BY ResourceManagerId


GO
