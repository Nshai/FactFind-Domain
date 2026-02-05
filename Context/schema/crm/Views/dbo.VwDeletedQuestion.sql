SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedQuestion]
AS
  SELECT 
    QuestionId, 
    'AuditId' = MAX(AuditId)
  FROM TQuestionAudit
  WHERE StampAction = 'D'
  GROUP BY QuestionId


GO
