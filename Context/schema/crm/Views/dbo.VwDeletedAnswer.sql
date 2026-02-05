SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedAnswer]
AS
  SELECT 
    AnswerId, 
    'AuditId' = MAX(AuditId)
  FROM TAnswerAudit
  WHERE StampAction = 'D'
  GROUP BY AnswerId


GO
