SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedIndigoClient]
AS
  SELECT 
    IndigoClientId, 
    'AuditId' = MAX(AuditId)
  FROM TIndigoClientAudit
  WHERE StampAction = 'D'
  GROUP BY IndigoClientId


GO
