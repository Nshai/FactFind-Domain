SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedBenefit]
AS
  SELECT 
    BenefitId, 
    'AuditId' = MAX(AuditId)
  FROM TBenefitAudit
  WHERE StampAction = 'D'
  GROUP BY BenefitId


GO
