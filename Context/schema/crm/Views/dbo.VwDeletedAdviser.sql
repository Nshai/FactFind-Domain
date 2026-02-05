SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedAdviser]
AS
  SELECT 
    AdviserId, 
    'AuditId' = MAX(AuditId)
  FROM TAdviserAudit
  WHERE StampAction = 'D'
  GROUP BY AdviserId


GO
