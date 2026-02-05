SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPolicyDetail]
AS
  SELECT 
    PolicyDetailId, 
    'AuditId' = MAX(AuditId)
  FROM TPolicyDetailAudit
  WHERE StampAction = 'D'
  GROUP BY PolicyDetailId


GO
