SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefPriority]
AS
  SELECT 
    RefPriorityId, 
    'AuditId' = MAX(AuditId)
  FROM TRefPriorityAudit
  WHERE StampAction = 'D'
  GROUP BY RefPriorityId

GO
