SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefServiceStatus]
AS
  SELECT 
    RefServiceStatusId, 
    'AuditId' = MAX(AuditId)
  FROM TRefServiceStatusAudit
  WHERE StampAction = 'D'
  GROUP BY RefServiceStatusId


GO
