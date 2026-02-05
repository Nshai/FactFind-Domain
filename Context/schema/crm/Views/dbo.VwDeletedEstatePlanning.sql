SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedEstatePlanning]
AS
  SELECT 
    EstatePlanningId, 
    'AuditId' = MAX(AuditId)
  FROM TEstatePlanningAudit
  WHERE StampAction = 'D'
  GROUP BY EstatePlanningId


GO
