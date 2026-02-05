SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefIndexationType]
AS
  SELECT 
    RefIndexationTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefIndexationTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefIndexationTypeId


GO
