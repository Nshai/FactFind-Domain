SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedEntity]
AS
  SELECT 
    EntityId, 
    'AuditId' = MAX(AuditId)
  FROM TEntityAudit
  WHERE StampAction = 'D'
  GROUP BY EntityId


GO
