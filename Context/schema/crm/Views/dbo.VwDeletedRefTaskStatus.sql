SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefTaskStatus]
AS
  SELECT 
    RefTaskStatusId, 
    'AuditId' = MAX(AuditId)
  FROM TRefTaskStatusAudit
  WHERE StampAction = 'D'
  GROUP BY RefTaskStatusId


GO
