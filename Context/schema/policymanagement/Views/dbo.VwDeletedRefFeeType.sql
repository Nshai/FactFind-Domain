SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefFeeType]
AS
  SELECT 
    RefFeeTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TRefFeeTypeAudit
  WHERE StampAction = 'D'
  GROUP BY RefFeeTypeId


GO
