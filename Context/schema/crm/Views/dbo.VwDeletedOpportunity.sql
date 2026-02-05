SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedOpportunity]
AS
  SELECT 
    OpportunityId, 
    'AuditId' = MAX(AuditId)
  FROM TOpportunityAudit
  WHERE StampAction = 'D'
  GROUP BY OpportunityId


GO
