SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefCategory]
AS
  SELECT 
    RefCategoryId, 
    'AuditId' = MAX(AuditId)
  FROM TRefCategoryAudit
  WHERE StampAction = 'D'
  GROUP BY RefCategoryId


GO
