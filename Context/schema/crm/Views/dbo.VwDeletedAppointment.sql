SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedAppointment]
AS
  SELECT 
    AppointmentId, 
    'AuditId' = MAX(AuditId)
  FROM TAppointmentAudit
  WHERE StampAction = 'D'
  GROUP BY AppointmentId

GO
