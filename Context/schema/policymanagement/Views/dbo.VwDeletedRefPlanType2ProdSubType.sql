SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefPlanType2ProdSubType]
AS
  SELECT 
    RefPlanType2ProdSubTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefPlanType2ProdSubTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefPlanType2ProdSubTypeId


GO
