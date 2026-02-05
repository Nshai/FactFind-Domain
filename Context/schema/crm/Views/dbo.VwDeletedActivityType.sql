SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedActivityType]
AS
  SELECT 
    ActivityTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TActivityTypeAudit
  WHERE StampAction = 'D'
  GROUP BY ActivityTypeId


GO
