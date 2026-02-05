SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefNetwork]
AS
  SELECT 
    RefNetworkId, 
    'AuditId' = MAX(AuditId)
  FROM TRefNetworkAudit
  WHERE StampAction = 'D'
  GROUP BY RefNetworkId


GO
