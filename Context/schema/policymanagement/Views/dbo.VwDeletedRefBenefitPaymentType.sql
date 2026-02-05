SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefBenefitPaymentType]
AS
  SELECT 
    RefBenefitPaymentTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefBenefitPaymentTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefBenefitPaymentTypeId


GO
