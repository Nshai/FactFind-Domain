SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefSubject]
AS
  SELECT 
    RefSubjectId, 
    'AuditId' = MAX(AuditId)
  FROM TRefSubjectAudit
  WHERE StampAction = 'D'
  GROUP BY RefSubjectId


GO
