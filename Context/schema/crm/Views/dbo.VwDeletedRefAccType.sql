SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefAccType]
AS
  SELECT 
    RefAccTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefAccTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefAccTypeId


GO
