SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedAttributeList]
AS
  SELECT 
    AttributeListId, 
    'AuditId' = MAX(AuditId)
  FROM TAttributeListAudit
  WHERE StampAction = 'D'
  GROUP BY AttributeListId


GO
