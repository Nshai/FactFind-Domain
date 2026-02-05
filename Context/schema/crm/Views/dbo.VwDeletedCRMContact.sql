SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedCRMContact]
AS
  SELECT 
    CRMContactId, 
    'AuditId' = MAX(AuditId)
  FROM TCRMContactAudit
  WHERE StampAction = 'D'
  GROUP BY CRMContactId


GO
