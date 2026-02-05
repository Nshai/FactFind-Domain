SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefSourceOfClient]
AS
  SELECT 
    RefSourceOfClientId, 
    'AuditId' = MAX(AuditId)
  FROM TRefSourceOfClientAudit
  WHERE StampAction = 'D'
  GROUP BY RefSourceOfClientId


GO
