SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRefAcceptanceStatus]
AS
  SELECT 
    RefAcceptanceStatusId, 
    'AuditId' = MAX(AuditId)
  FROM TRefAcceptanceStatusAudit
  WHERE StampAction = 'D'
  GROUP BY RefAcceptanceStatusId

GO
