SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveAddressStoreById]
@AddressStoreId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.AddressStoreId AS [AddressStore!1!AddressStoreId], 
    T1.IndClientId AS [AddressStore!1!IndClientId], 
    ISNULL(T1.AddressLine1, '') AS [AddressStore!1!AddressLine1], 
    ISNULL(T1.AddressLine2, '') AS [AddressStore!1!AddressLine2], 
    ISNULL(T1.AddressLine3, '') AS [AddressStore!1!AddressLine3], 
    ISNULL(T1.AddressLine4, '') AS [AddressStore!1!AddressLine4], 
    ISNULL(T1.CityTown, '') AS [AddressStore!1!CityTown], 
    ISNULL(T1.RefCountyId, '') AS [AddressStore!1!RefCountyId], 
    ISNULL(T1.Postcode, '') AS [AddressStore!1!Postcode], 
    ISNULL(T1.RefCountryId, '') AS [AddressStore!1!RefCountryId], 
    ISNULL(T1.PostCodeX, '') AS [AddressStore!1!PostCodeX], 
    ISNULL(T1.PostCodeY, '') AS [AddressStore!1!PostCodeY], 
    T1.ConcurrencyId AS [AddressStore!1!ConcurrencyId]
  FROM TAddressStore T1

  WHERE (T1.AddressStoreId = @AddressStoreId)

  ORDER BY [AddressStore!1!AddressStoreId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
