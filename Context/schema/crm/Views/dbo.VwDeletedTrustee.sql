SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedTrustee]
AS
  SELECT 
    TrusteeId, 
    'AuditId' = MAX(AuditId)
  FROM TTrusteeAudit
  WHERE StampAction = 'D'
  GROUP BY TrusteeId


GO
