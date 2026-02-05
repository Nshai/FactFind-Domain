SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefPlanType]
AS
  SELECT 
    RefPlanTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefPlanTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefPlanTypeId


GO
