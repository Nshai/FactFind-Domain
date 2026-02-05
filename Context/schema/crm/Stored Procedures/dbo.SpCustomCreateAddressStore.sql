SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCustomCreateAddressStore]
@StampUser varchar (255),
@IndClientId bigint,
@AddressLine1 varchar (1000) = NULL,
@AddressLine2 varchar (1000) = NULL,
@AddressLine3 varchar (1000) = NULL,
@AddressLine4 varchar (1000) = NULL,
@CityTown varchar (255) = NULL,
@RefCountyId bigint = NULL,
@Postcode varchar (20) = NULL,
@RefCountryId bigint = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @AddressStoreId bigint
  DECLARE @PostCodeX bigint
  DECLARE @PostCodeY bigint
  DECLARE @PostCodeLatitudeX decimal (18,8)
  DECLARE @PostCodeLongitudeY decimal (18,8)
  DECLARE @FirstPartPostCode varchar (20)

  SELECT @PostCodeX = NULL
  SELECT @PostCodeY = NULL
  SELECT @PostCodeLatitudeX = NULL
  SELECT @PostCodeLongitudeY = NULL

  SELECT @PostCode = LTRIM(RTRIM(@PostCode))

  IF LEN(@PostCode) > 0 
  BEGIN
	IF LEN(@PostCode) > 4
		--Post code contains more than just the first part (ie: sw19 4ds)
		BEGIN
			--Drop last 3 post code characters to extract the first part only
			SELECT @FirstPartPostCode = LTRIM(RTRIM(LEFT(@PostCode, LEN(@PostCode) - 3)))
		END

	ELSE

		BEGIN
			SELECT @FirstPartPostCode = @PostCode
		END
  END
			
			
  SELECT @PostCodeLatitudeX = (SELECT LatitudeX FROM TPostCode WHERE PostCodeShortName = @FirstPartPostCode)
  SELECT @PostCodeLongitudeY = (SELECT LongitudeY FROM TPostCode WHERE PostCodeShortName = @FirstPartPostCode)

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
    PostCodeLatitudeX,
	PostCodeLongitudeY,
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
    @PostCodeLatitudeX,
	@PostCodeLongitudeY,
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
