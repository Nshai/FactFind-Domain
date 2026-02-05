SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefOpportunityStage]
AS
  SELECT 
    RefOpportunityStageId, 
    'AuditId' = MAX(AuditId)
  FROM TRefOpportunityStageAudit
  WHERE StampAction = 'D'
  GROUP BY RefOpportunityStageId


GO
