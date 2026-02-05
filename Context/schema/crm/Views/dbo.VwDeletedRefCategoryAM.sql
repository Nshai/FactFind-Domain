SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefCategoryAM]
AS
  SELECT 
    RefCategoryAMId, 
    'AuditId' = MAX(AuditId)
  FROM TRefCategoryAMAudit
  WHERE StampAction = 'D'
  GROUP BY RefCategoryAMId


GO
