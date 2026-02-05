SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedProperty]
AS
  SELECT 
    PropertyId, 
    'AuditId' = MAX(AuditId)
  FROM TPropertyAudit
  WHERE StampAction = 'D'
  GROUP BY PropertyId


GO
