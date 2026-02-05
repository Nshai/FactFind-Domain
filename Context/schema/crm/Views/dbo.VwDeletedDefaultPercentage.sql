SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedDefaultPercentage]
AS
  SELECT 
    DefaultPercentageId, 
    'AuditId' = MAX(AuditId)
  FROM TDefaultPercentageAudit
  WHERE StampAction = 'D'
  GROUP BY DefaultPercentageId


GO
