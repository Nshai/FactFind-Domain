SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedOrganiserActivity]
AS
  SELECT 
    OrganiserActivityId, 
    'AuditId' = MAX(AuditId)
  FROM TOrganiserActivityAudit
  WHERE StampAction = 'D'
  GROUP BY OrganiserActivityId

GO
