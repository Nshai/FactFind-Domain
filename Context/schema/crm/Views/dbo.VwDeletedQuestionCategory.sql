SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedQuestionCategory]
AS
  SELECT 
    QuestionCategoryId, 
    'AuditId' = MAX(AuditId)
  FROM TQuestionCategoryAudit
  WHERE StampAction = 'D'
  GROUP BY QuestionCategoryId


GO
