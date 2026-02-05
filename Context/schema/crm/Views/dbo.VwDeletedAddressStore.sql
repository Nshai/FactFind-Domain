SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedAddressStore]
AS
  SELECT 
    AddressStoreId, 
    'AuditId' = MAX(AuditId)
  FROM TAddressStoreAudit
  WHERE StampAction = 'D'
  GROUP BY AddressStoreId


GO
