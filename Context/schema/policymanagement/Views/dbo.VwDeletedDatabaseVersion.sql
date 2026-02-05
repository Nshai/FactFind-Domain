SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedDatabaseVersion]
AS
  SELECT 
    DatabaseVersionId, 
    'AuditId' = MAX(AuditId)
  FROM TDatabaseVersionAudit
  WHERE StampAction = 'D'
  GROUP BY DatabaseVersionId


GO
