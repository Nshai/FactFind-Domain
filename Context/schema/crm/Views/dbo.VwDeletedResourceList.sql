SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedResourceList]
AS
  SELECT 
    ResourceListId, 
    'AuditId' = MAX(AuditId)
  FROM TResourceListAudit
  WHERE StampAction = 'D'
  GROUP BY ResourceListId

GO
