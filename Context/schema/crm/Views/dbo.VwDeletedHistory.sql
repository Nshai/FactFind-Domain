SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedHistory]
AS
  SELECT 
    HistoryId, 
    'AuditId' = MAX(AuditId)
  FROM THistoryAudit
  WHERE StampAction = 'D'
  GROUP BY HistoryId


GO
