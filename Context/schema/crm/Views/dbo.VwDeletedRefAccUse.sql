SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefAccUse]
AS
  SELECT 
    RefAccUseId, 
    'AuditId' = MAX(AuditId)
  FROM TRefAccUseAudit
  WHERE StampAction = 'D'
  GROUP BY RefAccUseId


GO
