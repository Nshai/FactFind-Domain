SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedContact]
AS
  SELECT 
    ContactId, 
    'AuditId' = MAX(AuditId)
  FROM TContactAudit
  WHERE StampAction = 'D'
  GROUP BY ContactId


GO
