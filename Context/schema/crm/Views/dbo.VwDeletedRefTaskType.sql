SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefTaskType]
AS
  SELECT 
    RefTaskTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefTaskTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefTaskTypeId


GO
