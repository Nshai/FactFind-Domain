SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedGrouping]
AS
  SELECT 
    GroupingId, 
    'AuditId' = MAX(AuditId)
  FROM TGroupingAudit
  WHERE StampAction = 'D'
  GROUP BY GroupingId


GO
