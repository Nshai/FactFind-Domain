SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPolicyFund]
AS
  SELECT 
    PolicyFundId, 
    'AuditId' = MAX(AuditId)
  FROM TPolicyFundAudit
  WHERE StampAction = 'D'
  GROUP BY PolicyFundId


GO
