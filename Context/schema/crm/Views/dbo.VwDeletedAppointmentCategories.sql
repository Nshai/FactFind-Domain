SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedAppointmentCategories]
AS
  SELECT 
    AppointmentCategoriesId, 
    'AuditId' = MAX(AuditId)
  FROM TAppointmentCategoriesAudit
  WHERE StampAction = 'D'
  GROUP BY AppointmentCategoriesId


GO
