SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefGroupType]
AS
  SELECT 
    RefGroupTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefGroupTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefGroupTypeId



GO
