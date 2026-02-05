SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedTarget]
AS
  SELECT 
    TargetId, 
    'AuditId' = MAX(AuditId)
  FROM TTargetAudit
  WHERE StampAction = 'D'
  GROUP BY TargetId


GO
