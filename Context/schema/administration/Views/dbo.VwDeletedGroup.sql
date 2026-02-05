SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedGroup]
AS
  SELECT 
    GroupId, 
    'AuditId' = MAX(AuditId)
  FROM TGroupAudit
  WHERE StampAction = 'D'
  GROUP BY GroupId


GO
