SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedClient]
AS
  SELECT 
    ClientId, 
    'AuditId' = MAX(AuditId)
  FROM TClientAudit
  WHERE StampAction = 'D'
  GROUP BY ClientId



GO
