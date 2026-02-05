SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedReminder]
AS
  SELECT 
    ReminderId, 
    'AuditId' = MAX(AuditId)
  FROM TReminderAudit
  WHERE StampAction = 'D'
  GROUP BY ReminderId

GO
