SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefCRMContactStatus]
AS
  SELECT 
    RefCRMContactStatusId, 
    'AuditId' = MAX(AuditId)
  FROM TRefCRMContactStatusAudit
  WHERE StampAction = 'D'
  GROUP BY RefCRMContactStatusId


GO
