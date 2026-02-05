SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedQADropDownItem]
AS
  SELECT 
    QADropDownItemId, 
    'AuditId' = MAX(AuditId)
  FROM TQADropDownItemAudit
  WHERE StampAction = 'D'
  GROUP BY QADropDownItemId


GO
