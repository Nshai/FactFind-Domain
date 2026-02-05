SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefPaymentBasisType]
AS
  SELECT 
    RefPaymentBasisTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefPaymentBasisTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefPaymentBasisTypeId


GO
