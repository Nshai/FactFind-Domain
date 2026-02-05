SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefContactType]
AS
  SELECT 
    RefContactTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefContactTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefContactTypeId


GO
