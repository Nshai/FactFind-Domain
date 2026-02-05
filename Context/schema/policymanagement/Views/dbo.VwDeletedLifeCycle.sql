SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedLifeCycle]
AS
  SELECT 
    LifeCycleId, 
    'AuditId' = MAX(AuditId)
  FROM TLifeCycleAudit
  WHERE StampAction = 'D'
  GROUP BY LifeCycleId

GO
