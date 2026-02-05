SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedIndigoClientProvider]
AS
  SELECT 
    IndigoClientProviderId, 
    'AuditId' = MAX(AuditId)
  FROM TIndigoClientProviderAudit
  WHERE StampAction = 'D'
  GROUP BY IndigoClientProviderId


GO
