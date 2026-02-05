SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRole]
AS
  SELECT 
    RoleId, 
    'AuditId' = MAX(AuditId)
  FROM TRoleAudit
  WHERE StampAction = 'D'
  GROUP BY RoleId


GO
