SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedCategoryPlanType]
AS
  SELECT 
    CategoryPlanTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TCategoryPlanTypeAudit
  WHERE StampAction = 'D'
  GROUP BY CategoryPlanTypeId


GO
