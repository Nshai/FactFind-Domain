SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRiskAttitude]
AS
  SELECT 
    RiskAttitudeId, 
    'AuditId' = MAX(AuditId)
  FROM TRiskAttitudeAudit
  WHERE StampAction = 'D'
  GROUP BY RiskAttitudeId


GO
