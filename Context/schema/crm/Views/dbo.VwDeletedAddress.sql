SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedAddress]
AS
  SELECT 
    AddressId, 
    'AuditId' = MAX(AuditId)
  FROM TAddressAudit
  WHERE StampAction = 'D'
  GROUP BY AddressId


GO
