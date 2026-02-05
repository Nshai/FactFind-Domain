SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedActivityCategory]
AS
  SELECT 
    ActivityCategoryId, 
    'AuditId' = MAX(AuditId)
  FROM TActivityCategoryAudit
  WHERE StampAction = 'D'
  GROUP BY ActivityCategoryId

GO
