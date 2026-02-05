SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedMembership]
AS
  SELECT 
    MembershipId, 
    'AuditId' = MAX(AuditId)
  FROM TMembershipAudit
  WHERE StampAction = 'D'
  GROUP BY MembershipId


GO
