SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPlanTypePurpose]
AS
  SELECT 
    PlanTypePurposeId, 
    'AuditId' = MAX(AuditId)
  FROM TPlanTypePurposeAudit
  WHERE StampAction = 'D'
  GROUP BY PlanTypePurposeId


GO
