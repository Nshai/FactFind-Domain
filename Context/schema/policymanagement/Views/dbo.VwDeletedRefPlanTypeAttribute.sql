SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefPlanTypeAttribute]
AS
  SELECT 
    RefPlanTypeAttributeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefPlanTypeAttributeAudit
  WHERE StampAction = 'D'
  GROUP BY RefPlanTypeAttributeId


GO
