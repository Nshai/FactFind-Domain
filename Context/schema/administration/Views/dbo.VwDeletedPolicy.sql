SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPolicy]
AS
  SELECT 
    PolicyId, 
    'AuditId' = MAX(AuditId)
  FROM TPolicyAudit
  WHERE StampAction = 'D'
  GROUP BY PolicyId


GO
