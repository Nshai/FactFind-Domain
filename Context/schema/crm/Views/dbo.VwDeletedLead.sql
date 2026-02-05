SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedLead]
AS
  SELECT 
    LeadId, 
    'AuditId' = MAX(AuditId)
  FROM TLeadAudit
  WHERE StampAction = 'D'
  GROUP BY LeadId

GO
