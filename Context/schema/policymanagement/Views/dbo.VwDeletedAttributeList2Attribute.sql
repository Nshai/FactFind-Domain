SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedAttributeList2Attribute]
AS
  SELECT 
    AttributeList2AttributeId, 
    'AuditId' = MAX(AuditId)
  FROM TAttributeList2AttributeAudit
  WHERE StampAction = 'D'
  GROUP BY AttributeList2AttributeId


GO
