SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefRelationshipTypeLink]
AS
  SELECT 
    RefRelationshipTypeLinkId, 
    'AuditId' = MAX(AuditId)
  FROM TRefRelationshipTypeLinkAudit
  WHERE StampAction = 'D'
  GROUP BY RefRelationshipTypeLinkId


GO
