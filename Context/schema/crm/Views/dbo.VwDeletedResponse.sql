SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedResponse]
AS
  SELECT 
    ResponseId, 
    'AuditId' = MAX(AuditId)
  FROM TResponseAudit
  WHERE StampAction = 'D'
  GROUP BY ResponseId


GO
