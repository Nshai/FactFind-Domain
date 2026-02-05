SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRiskQuestion]
AS
  SELECT 
    RiskQuestionId, 
    'AuditId' = MAX(AuditId)
  FROM TRiskQuestionAudit
  WHERE StampAction = 'D'
  GROUP BY RiskQuestionId



GO
