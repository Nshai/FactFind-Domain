SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedQAirLinkQuestion]
AS
  SELECT 
    QAirLinkQuestionId, 
    'AuditId' = MAX(AuditId)
  FROM TQAirLinkQuestionAudit
  WHERE StampAction = 'D'
  GROUP BY QAirLinkQuestionId


GO
