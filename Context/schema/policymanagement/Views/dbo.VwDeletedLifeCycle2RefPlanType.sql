SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedLifeCycle2RefPlanType]
AS
  SELECT 
    LifeCycle2RefPlanTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TLifeCycle2RefPlanTypeAudit
  WHERE StampAction = 'D'
  GROUP BY LifeCycle2RefPlanTypeId

GO
