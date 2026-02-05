SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedKey]
AS
  SELECT 
    KeyId, 
    'AuditId' = MAX(AuditId)
  FROM TKeyAudit
  WHERE StampAction = 'D'
  GROUP BY KeyId


GO
