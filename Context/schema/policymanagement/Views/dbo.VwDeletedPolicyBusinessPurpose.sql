SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPolicyBusinessPurpose]
AS
  SELECT 
    PolicyBusinessPurposeId, 
    'AuditId' = MAX(AuditId)
  FROM TPolicyBusinessPurposeAudit
  WHERE StampAction = 'D'
  GROUP BY PolicyBusinessPurposeId


GO
