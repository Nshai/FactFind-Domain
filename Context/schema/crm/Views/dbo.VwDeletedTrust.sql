SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedTrust]
AS
  SELECT 
    TrustId, 
    'AuditId' = MAX(AuditId)
  FROM TTrustAudit
  WHERE StampAction = 'D'
  GROUP BY TrustId


GO
