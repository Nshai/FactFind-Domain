SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRiskRange]
AS
  SELECT 
    RiskRangeId, 
    'AuditId' = MAX(AuditId)
  FROM TRiskRangeAudit
  WHERE StampAction = 'D'
  GROUP BY RiskRangeId


GO
