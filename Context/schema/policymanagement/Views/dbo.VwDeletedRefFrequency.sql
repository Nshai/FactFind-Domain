SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefFrequency]
AS
  SELECT 
    RefFrequencyId, 
    'AuditId' = MAX(AuditId)
  FROM TRefFrequencyAudit
  WHERE StampAction = 'D'
  GROUP BY RefFrequencyId


GO
