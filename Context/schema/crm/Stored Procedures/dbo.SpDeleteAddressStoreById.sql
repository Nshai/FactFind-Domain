SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpDeleteAddressStoreById]
@AddressStoreId bigint,
@StampUser varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TAddressStoreAudit (
    IndClientId, 
    AddressLine1, 
    AddressLine2, 
    AddressLine3, 
    AddressLine4, 
    CityTown, 
    RefCountyId, 
    Postcode, 
    RefCountryId, 
    PostCodeX, 
    PostCodeY,
    PostCodeLatitudeX,
    PostCodeLongitudeY, 
    ConcurrencyId,
    AddressStoreId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.IndClientId, 
    T1.AddressLine1, 
    T1.AddressLine2, 
    T1.AddressLine3, 
    T1.AddressLine4, 
    T1.CityTown, 
    T1.RefCountyId, 
    T1.Postcode, 
    T1.RefCountryId, 
    T1.PostCodeX, 
    T1.PostCodeY, 
    T1.PostCodeLatitudeX,
    T1.PostCodeLongitudeY, 
    T1.ConcurrencyId,
    T1.AddressStoreId,
    'D',
    GetDate(),
    @StampUser

  FROM TAddressStore T1

  WHERE (T1.AddressStoreId = @AddressStoreId)
  DELETE T1 FROM TAddressStore T1

  WHERE (T1.AddressStoreId = @AddressStoreId)


  SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
