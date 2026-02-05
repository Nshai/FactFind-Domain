SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefRelationshipType]
AS
  SELECT 
    RefRelationshipTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefRelationshipTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefRelationshipTypeId


GO
