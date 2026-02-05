SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedLifeCycleStep]
AS
  SELECT 
    LifeCycleStepId, 
    'AuditId' = MAX(AuditId)
  FROM TLifeCycleStepAudit
  WHERE StampAction = 'D'
  GROUP BY LifeCycleStepId

GO
