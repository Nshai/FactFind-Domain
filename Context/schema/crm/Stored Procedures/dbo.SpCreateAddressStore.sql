SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateAddressStore]
@StampUser varchar (255),
@IndClientId bigint,
@AddressLine1 varchar (1000) = NULL,
@AddressLine2 varchar (1000) = NULL,
@AddressLine3 varchar (1000) = NULL,
@AddressLine4 varchar (1000) = NULL,
@CityTown varchar (255) = NULL,
@RefCountyId bigint = NULL,
@Postcode varchar (20) = NULL,
@RefCountryId bigint = NULL,
@PostCodeX bigint = NULL,
@PostCodeY bigint = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @AddressStoreId bigint

  INSERT INTO TAddressStore (
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
    ConcurrencyId ) 
  VALUES (
    @IndClientId, 
    @AddressLine1, 
    @AddressLine2, 
    @AddressLine3, 
    @AddressLine4, 
    @CityTown, 
    @RefCountyId, 
    @Postcode, 
    @RefCountryId, 
    @PostCodeX, 
    @PostCodeY, 
    1) 

  SELECT @AddressStoreId = SCOPE_IDENTITY()
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
    T1.ConcurrencyId,
    T1.AddressStoreId,
    'C',
    GetDate(),
    @StampUser

  FROM TAddressStore T1
 WHERE T1.AddressStoreId=@AddressStoreId
  EXEC SpRetrieveAddressStoreById @AddressStoreId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
