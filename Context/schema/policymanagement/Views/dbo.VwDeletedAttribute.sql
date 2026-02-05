SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedAttribute]
AS
  SELECT 
    AttributeId, 
    'AuditId' = MAX(AuditId)
  FROM TAttributeAudit
  WHERE StampAction = 'D'
  GROUP BY AttributeId


GO
