SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPlanPurpose]
AS
  SELECT 
    PlanPurposeId, 
    'AuditId' = MAX(AuditId)
  FROM TPlanPurposeAudit
  WHERE StampAction = 'D'
  GROUP BY PlanPurposeId


GO
