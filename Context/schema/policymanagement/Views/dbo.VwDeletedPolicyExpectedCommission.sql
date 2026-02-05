SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPolicyExpectedCommission]
AS
  SELECT 
    PolicyExpectedCommissionId, 
    'AuditId' = MAX(AuditId)
  FROM TPolicyExpectedCommissionAudit
  WHERE StampAction = 'D'
  GROUP BY PolicyExpectedCommissionId


GO
