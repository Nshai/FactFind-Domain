SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefCorporateType]
AS
  SELECT 
    RefCorporateTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefCorporateTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefCorporateTypeId


GO
