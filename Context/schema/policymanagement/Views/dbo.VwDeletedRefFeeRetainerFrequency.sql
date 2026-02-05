SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefFeeRetainerFrequency]
AS
  SELECT 
    RefFeeRetainerFrequencyId, 
    'AuditId' = MAX(AuditId)
  FROM TRefFeeRetainerFrequencyAudit
  WHERE StampAction = 'D'
  GROUP BY RefFeeRetainerFrequencyId


GO
