SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefObjective]
AS
  SELECT 
    RefObjectiveId, 
    'AuditId' = MAX(AuditId)
  FROM TRefObjectiveAudit
  WHERE StampAction = 'D'
  GROUP BY RefObjectiveId


GO
