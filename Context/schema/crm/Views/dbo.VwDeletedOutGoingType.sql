SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedOutGoingType]
AS
  SELECT 
    OutGoingTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TOutGoingTypeAudit
  WHERE StampAction = 'D'
  GROUP BY OutGoingTypeId


GO
