SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedAnnouncement]
AS
  SELECT 
    AnnouncementId, 
    'AuditId' = MAX(AuditId)
  FROM TAnnouncementAudit
  WHERE StampAction = 'D'
  GROUP BY AnnouncementId


GO
