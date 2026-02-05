SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedQADropDownList]
AS
  SELECT 
    QADropDownListId, 
    'AuditId' = MAX(AuditId)
  FROM TQADropDownListAudit
  WHERE StampAction = 'D'
  GROUP BY QADropDownListId


GO
