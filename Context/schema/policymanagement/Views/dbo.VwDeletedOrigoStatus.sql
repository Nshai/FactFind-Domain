SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedOrigoStatus]
AS
  SELECT 
    OrigoStatusId, 
    'AuditId' = MAX(AuditId)
  FROM TOrigoStatusAudit
  WHERE StampAction = 'D'
  GROUP BY OrigoStatusId


GO
