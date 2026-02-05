SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedQADependentQuestion]
AS
  SELECT 
    QADependentQuestionId, 
    'AuditId' = MAX(AuditId)
  FROM TQADependentQuestionAudit
  WHERE StampAction = 'D'
  GROUP BY QADependentQuestionId


GO
