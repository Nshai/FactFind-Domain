SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefTrustType]
AS
  SELECT 
    RefTrustTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefTrustTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefTrustTypeId


GO
