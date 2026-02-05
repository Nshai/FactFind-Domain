SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefShowTimeAs]
AS
  SELECT 
    RefShowTimeAsId, 
    'AuditId' = MAX(AuditId)
  FROM TRefShowTimeAsAudit
  WHERE StampAction = 'D'
  GROUP BY RefShowTimeAsId


GO
