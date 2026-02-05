SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPolicyBusinessAttribute]
AS
  SELECT 
    PolicyBusinessAttributeId, 
    'AuditId' = MAX(AuditId)
  FROM TPolicyBusinessAttributeAudit
  WHERE StampAction = 'D'
  GROUP BY PolicyBusinessAttributeId


GO
