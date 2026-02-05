SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedAttendees]
AS
  SELECT 
    AttendeesId, 
    'AuditId' = MAX(AuditId)
  FROM TAttendeesAudit
  WHERE StampAction = 'D'
  GROUP BY AttendeesId

GO
