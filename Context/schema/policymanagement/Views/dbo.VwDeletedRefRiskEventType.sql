SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefRiskEventType]
AS
  SELECT 
    RefRiskEventTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefRiskEventTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefRiskEventTypeId


GO
