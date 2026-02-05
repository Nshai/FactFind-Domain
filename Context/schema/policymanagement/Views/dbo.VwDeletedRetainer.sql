SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRetainer]
AS
  SELECT 
    RetainerId, 
    'AuditId' = MAX(AuditId)
  FROM TRetainerAudit
  WHERE StampAction = 'D'
  GROUP BY RetainerId


GO
