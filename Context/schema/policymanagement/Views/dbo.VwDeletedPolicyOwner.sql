SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPolicyOwner]
AS
  SELECT 
    PolicyOwnerId, 
    'AuditId' = MAX(AuditId)
  FROM TPolicyOwnerAudit
  WHERE StampAction = 'D'
  GROUP BY PolicyOwnerId


GO
