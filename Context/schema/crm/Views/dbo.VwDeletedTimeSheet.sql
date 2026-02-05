SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedTimeSheet]
AS
  SELECT 
    TimeSheetId, 
    'AuditId' = MAX(AuditId)
  FROM TTimeSheetAudit
  WHERE StampAction = 'D'
  GROUP BY TimeSheetId


GO
