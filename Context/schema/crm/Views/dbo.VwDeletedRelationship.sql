SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRelationship]
AS
  SELECT 
    RelationshipId, 
    'AuditId' = MAX(AuditId)
  FROM TRelationshipAudit
  WHERE StampAction = 'D'
  GROUP BY RelationshipId


GO
