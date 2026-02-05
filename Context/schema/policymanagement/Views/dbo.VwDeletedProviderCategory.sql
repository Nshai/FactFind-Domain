SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedProviderCategory]
AS
  SELECT 
    ProviderCategoryId, 
    'AuditId' = MAX(AuditId)
  FROM TProviderCategoryAudit
  WHERE StampAction = 'D'
  GROUP BY ProviderCategoryId




GO
