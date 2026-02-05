SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPolicyMoneyIn]
AS
  SELECT 
    PolicyMoneyInId, 
    'AuditId' = MAX(AuditId)
  FROM TPolicyMoneyInAudit
  WHERE StampAction = 'D'
  GROUP BY PolicyMoneyInId


GO
