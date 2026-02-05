SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedQuestionnaire]
AS
  SELECT 
    QuestionnaireId, 
    'AuditId' = MAX(AuditId)
  FROM TQuestionnaireAudit
  WHERE StampAction = 'D'
  GROUP BY QuestionnaireId


GO
