SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedStatusHistory]
AS
  SELECT 
    StatusHistoryId, 
    'AuditId' = MAX(AuditId)
  FROM TStatusHistoryAudit
  WHERE StampAction = 'D'
  GROUP BY StatusHistoryId


GO
