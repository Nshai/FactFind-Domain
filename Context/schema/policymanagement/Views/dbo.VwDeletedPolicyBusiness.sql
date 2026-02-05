SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPolicyBusiness]
AS
  SELECT 
    PolicyBusinessId, 
    'AuditId' = MAX(AuditId)
  FROM TPolicyBusinessAudit
  WHERE StampAction = 'D'
  GROUP BY PolicyBusinessId


GO
