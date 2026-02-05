SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedTask]
AS
  SELECT 
    TaskId, 
    'AuditId' = MAX(AuditId)
  FROM TTaskAudit
  WHERE StampAction = 'D'
  GROUP BY TaskId

GO
