SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedTabName]
AS
  SELECT 
    TabNameId, 
    'AuditId' = MAX(AuditId)
  FROM TTabNameAudit
  WHERE StampAction = 'D'
  GROUP BY TabNameId


GO
