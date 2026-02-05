SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedQAirLinkCat]
AS
  SELECT 
    QAirLinkCatId, 
    'AuditId' = MAX(AuditId)
  FROM TQAirLinkCatAudit
  WHERE StampAction = 'D'
  GROUP BY QAirLinkCatId


GO
