SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefHistoryType]
AS
  SELECT 
    RefHistoryTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefHistoryTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefHistoryTypeId


GO
