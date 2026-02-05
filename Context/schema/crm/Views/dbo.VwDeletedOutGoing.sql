SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedOutGoing]
AS
  SELECT 
    OutGoingId, 
    'AuditId' = MAX(AuditId)
  FROM TOutGoingAudit
  WHERE StampAction = 'D'
  GROUP BY OutGoingId


GO
