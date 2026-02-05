SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedProductConnectionSetting]
AS
  SELECT 
    ProductConnectionSettingId, 
    'AuditId' = MAX(AuditId)
  FROM TProductConnectionSettingAudit
  WHERE StampAction = 'D'
  GROUP BY ProductConnectionSettingId


GO
