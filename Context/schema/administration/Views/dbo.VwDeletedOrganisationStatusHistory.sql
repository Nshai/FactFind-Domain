SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedOrganisationStatusHistory]
AS
  SELECT 
    OrganisationStatusHistoryId, 
    'AuditId' = MAX(AuditId)
  FROM TOrganisationStatusHistoryAudit
  WHERE StampAction = 'D'
  GROUP BY OrganisationStatusHistoryId

GO
