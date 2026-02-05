SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedOccupation]
AS
  SELECT 
    OccupationId, 
    'AuditId' = MAX(AuditId)
  FROM TOccupationAudit
  WHERE StampAction = 'D'
  GROUP BY OccupationId


GO
