SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedProduct]
AS
  SELECT 
    ProductId, 
    'AuditId' = MAX(AuditId)
  FROM TProductAudit
  WHERE StampAction = 'D'
  GROUP BY ProductId


GO
