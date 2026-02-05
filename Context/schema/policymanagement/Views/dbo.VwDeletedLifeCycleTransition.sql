SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedLifeCycleTransition]
AS
  SELECT 
    LifeCycleTransitionId, 
    'AuditId' = MAX(AuditId)
  FROM TLifeCycleTransitionAudit
  WHERE StampAction = 'D'
  GROUP BY LifeCycleTransitionId


GO
