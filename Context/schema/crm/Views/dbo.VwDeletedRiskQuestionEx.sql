SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRiskQuestionEx]
AS
  SELECT 
    ExtensibleColumnId, 
    'AuditId' = MAX(AuditId)
  FROM TRiskQuestionExAudit
  WHERE StampAction = 'D'
  GROUP BY ExtensibleColumnId



GO
