SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedCRMContactKey]
AS
  SELECT 
    CRMContactKeyId, 
    'AuditId' = MAX(AuditId)
  FROM TCRMContactKeyAudit
  WHERE StampAction = 'D'
  GROUP BY CRMContactKeyId


GO
