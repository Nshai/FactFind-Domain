SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefTaskView]
AS
  SELECT 
    RefTaskViewId, 
    'AuditId' = MAX(AuditId)
  FROM TRefTaskViewAudit
  WHERE StampAction = 'D'
  GROUP BY RefTaskViewId


GO
