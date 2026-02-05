SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefCounty]
AS
  SELECT 
    RefCountyId, 
    'AuditId' = MAX(AuditId)
  FROM TRefCountyAudit
  WHERE StampAction = 'D'
  GROUP BY RefCountyId


GO
