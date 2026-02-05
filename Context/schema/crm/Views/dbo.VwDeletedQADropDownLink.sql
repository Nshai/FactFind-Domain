SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedQADropDownLink]
AS
  SELECT 
    QADropDownLinkId, 
    'AuditId' = MAX(AuditId)
  FROM TQADropDownLinkAudit
  WHERE StampAction = 'D'
  GROUP BY QADropDownLinkId


GO
