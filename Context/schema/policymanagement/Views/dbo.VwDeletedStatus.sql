SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedStatus]
AS
  SELECT 
    StatusId, 
    'AuditId' = MAX(AuditId)
  FROM TStatusAudit
  WHERE StampAction = 'D'
  GROUP BY StatusId


GO
