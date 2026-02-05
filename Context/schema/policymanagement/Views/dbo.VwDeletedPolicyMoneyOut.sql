SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPolicyMoneyOut]
AS
  SELECT 
    PolicyMoneyOutId, 
    'AuditId' = MAX(AuditId)
  FROM TPolicyMoneyOutAudit
  WHERE StampAction = 'D'
  GROUP BY PolicyMoneyOutId


GO
