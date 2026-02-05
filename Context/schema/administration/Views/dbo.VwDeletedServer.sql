SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedServer]
AS
  SELECT 
    ServerId, 
    'AuditId' = MAX(AuditId)
  FROM TServerAudit
  WHERE StampAction = 'D'
  GROUP BY ServerId

GO
