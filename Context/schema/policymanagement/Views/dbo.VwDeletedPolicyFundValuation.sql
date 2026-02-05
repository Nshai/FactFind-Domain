SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPolicyFundValuation]
AS
  SELECT 
    PolicyFundValuationId, 
    'AuditId' = MAX(AuditId)
  FROM TPolicyFundValuationAudit
  WHERE StampAction = 'D'
  GROUP BY PolicyFundValuationId


GO
