SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedQVTLink]
AS
  SELECT 
    QVTLinkId, 
    'AuditId' = MAX(AuditId)
  FROM TQVTLinkAudit
  WHERE StampAction = 'D'
  GROUP BY QVTLinkId


GO
