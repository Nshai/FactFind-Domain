SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPlanCategory]
AS
  SELECT 
    PlanCategoryId, 
    'AuditId' = MAX(AuditId)
  FROM TPlanCategoryAudit
  WHERE StampAction = 'D'
  GROUP BY PlanCategoryId


GO
