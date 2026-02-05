SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedExecutor]
AS
  SELECT 
    ExecutorId, 
    'AuditId' = MAX(AuditId)
  FROM TExecutorAudit
  WHERE StampAction = 'D'
  GROUP BY ExecutorId


GO
