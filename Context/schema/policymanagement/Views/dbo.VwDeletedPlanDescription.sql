SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPlanDescription]
AS
  SELECT 
    PlanDescriptionId, 
    'AuditId' = MAX(AuditId)
  FROM TPlanDescriptionAudit
  WHERE StampAction = 'D'
  GROUP BY PlanDescriptionId


GO
