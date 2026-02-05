SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedPac]
AS
  SELECT 
    PacId, 
    'AuditId' = MAX(AuditId)
  FROM TPacAudit
  WHERE StampAction = 'D'
  GROUP BY PacId


GO
