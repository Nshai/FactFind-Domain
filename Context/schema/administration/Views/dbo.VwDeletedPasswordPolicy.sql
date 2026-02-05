SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPasswordPolicy]
AS
  SELECT 
    PasswordPolicyId, 
    'AuditId' = MAX(AuditId)
  FROM TPasswordPolicyAudit
  WHERE StampAction = 'D'
  GROUP BY PasswordPolicyId

GO
