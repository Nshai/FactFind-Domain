SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedEvent]
AS
  SELECT 
    EventId, 
    'AuditId' = MAX(AuditId)
  FROM TEventAudit
  WHERE StampAction = 'D'
  GROUP BY EventId


GO
