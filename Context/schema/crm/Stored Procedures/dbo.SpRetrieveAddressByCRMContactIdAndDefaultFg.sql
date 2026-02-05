SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveAddressByCRMContactIdAndDefaultFg]
@CRMContactId bigint,
@DefaultFg tinyint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.AddressId AS [Address!1!AddressId], 
    T1.IndClientId AS [Address!1!IndClientId], 
    ISNULL(T1.CRMContactId, '') AS [Address!1!CRMContactId], 
    ISNULL(T1.AddressStoreId, '') AS [Address!1!AddressStoreId], 
    T1.RefAddressTypeId AS [Address!1!RefAddressTypeId], 
    ISNULL(T1.AddressTypeName, '') AS [Address!1!AddressTypeName], 
    T1.DefaultFg AS [Address!1!DefaultFg], 
    T1.ConcurrencyId AS [Address!1!ConcurrencyId]
  FROM TAddress T1

  WHERE (T1.CRMContactId = @CRMContactId) AND 
        (T1.DefaultFg = @DefaultFg)

  ORDER BY [Address!1!AddressId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
