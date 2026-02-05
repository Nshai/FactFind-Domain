SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRetainerStatus]
AS
  SELECT 
    RetainerStatusId, 
    'AuditId' = MAX(AuditId)
  FROM TRetainerStatusAudit
  WHERE StampAction = 'D'
  GROUP BY RetainerStatusId


GO
