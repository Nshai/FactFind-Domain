SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPolicyBenefit]
AS
  SELECT 
    PolicyBenefitId, 
    'AuditId' = MAX(AuditId)
  FROM TPolicyBenefitAudit
  WHERE StampAction = 'D'
  GROUP BY PolicyBenefitId


GO
