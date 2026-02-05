SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedServiceLevel]
AS
  SELECT 
    ServiceLevelId, 
    'AuditId' = MAX(AuditId)
  FROM TServiceLevelAudit
  WHERE StampAction = 'D'
  GROUP BY ServiceLevelId

GO
