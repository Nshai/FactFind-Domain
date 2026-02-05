SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPolicyBeneficary]
AS
  SELECT 
    PolicyBeneficaryId, 
    'AuditId' = MAX(AuditId)
  FROM TPolicyBeneficaryAudit
  WHERE StampAction = 'D'
  GROUP BY PolicyBeneficaryId


GO
