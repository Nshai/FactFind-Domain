SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefSubjectAM]
AS
  SELECT 
    RefSubjectAMId, 
    'AuditId' = MAX(AuditId)
  FROM TRefSubjectAMAudit
  WHERE StampAction = 'D'
  GROUP BY RefSubjectAMId


GO
