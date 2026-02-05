SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedSwitch]
AS
  SELECT 
    SwitchId, 
    'AuditId' = MAX(AuditId)
  FROM TSwitchAudit
  WHERE StampAction = 'D'
  GROUP BY SwitchId


GO
