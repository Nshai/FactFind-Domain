SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefValuationBasis]
AS
  SELECT 
    RefValuationBasisId, 
    'AuditId' = MAX(AuditId)
  FROM TRefValuationBasisAudit
  WHERE StampAction = 'D'
  GROUP BY RefValuationBasisId


GO
