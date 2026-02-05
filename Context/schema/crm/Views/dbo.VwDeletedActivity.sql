SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedActivity]
AS
  SELECT 
    ActivityId, 
    'AuditId' = MAX(AuditId)
  FROM TActivityAudit
  WHERE StampAction = 'D'
  GROUP BY ActivityId


GO
