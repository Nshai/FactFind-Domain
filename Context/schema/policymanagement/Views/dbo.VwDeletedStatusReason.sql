SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedStatusReason]
AS
  SELECT 
    StatusReasonId, 
    'AuditId' = MAX(AuditId)
  FROM TStatusReasonAudit
  WHERE StampAction = 'D'
  GROUP BY StatusReasonId


GO
