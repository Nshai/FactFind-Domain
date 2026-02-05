SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPropertyOwnership]
AS
  SELECT 
    PropertyOwnershipId, 
    'AuditId' = MAX(AuditId)
  FROM TPropertyOwnershipAudit
  WHERE StampAction = 'D'
  GROUP BY PropertyOwnershipId


GO
