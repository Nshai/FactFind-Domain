SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedLeadSource]
AS
  SELECT 
    LeadSourceId, 
    'AuditId' = MAX(AuditId)
  FROM TLeadSourceAudit
  WHERE StampAction = 'D'
  GROUP BY LeadSourceId

GO
