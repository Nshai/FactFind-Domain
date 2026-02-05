SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefCommissionType]
AS
  SELECT 
    RefCommissionTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefCommissionTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefCommissionTypeId


GO
