SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRetired]
AS
  SELECT 
    RetiredId, 
    'AuditId' = MAX(AuditId)
  FROM TRetiredAudit
  WHERE StampAction = 'D'
  GROUP BY RetiredId


GO
