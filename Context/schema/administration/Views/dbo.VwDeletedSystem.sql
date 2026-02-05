SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedSystem]
AS
  SELECT 
    SystemId, 
    'AuditId' = MAX(AuditId)
  FROM TSystemAudit
  WHERE StampAction = 'D'
  GROUP BY SystemId


GO
