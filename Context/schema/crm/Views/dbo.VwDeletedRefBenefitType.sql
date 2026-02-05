SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefBenefitType]
AS
  SELECT 
    RefBenefitTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefBenefitTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefBenefitTypeId


GO
