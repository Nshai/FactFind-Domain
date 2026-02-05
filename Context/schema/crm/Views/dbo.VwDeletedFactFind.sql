SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedFactFind]
AS
  SELECT 
    FactFindId, 
    'AuditId' = MAX(AuditId)
  FROM TFactFindAudit
  WHERE StampAction = 'D'
  GROUP BY FactFindId


GO
