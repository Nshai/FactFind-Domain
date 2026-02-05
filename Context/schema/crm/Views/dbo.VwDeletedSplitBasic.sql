SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedSplitBasic]
AS
  SELECT 
    SplitBasicId, 
    'AuditId' = MAX(AuditId)
  FROM TSplitBasicAudit
  WHERE StampAction = 'D'
  GROUP BY SplitBasicId


GO
