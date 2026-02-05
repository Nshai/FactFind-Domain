SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCustomDeleteAddressAndContactInfo]
@AddressId bigint,
@StampUser varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TContactAddressAudit (
    ContactId, 
    AddressId, 
    ConcurrencyId,
    ContactAddressId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.ContactId, 
    T1.AddressId, 
    T1.ConcurrencyId,
    T1.ContactAddressId,
    'D',
    GetDate(),
    @StampUser

  FROM TContactAddress T1
  WHERE (T1.AddressId = @AddressId) 


  DELETE FROM TContactAddress WHERE AddressId = @AddressId

  DELETE FROM TContact WHERE ContactId IN (SELECT ContactId FROM TContactAddress WHERE AddressId = @AddressId)

  DELETE FROM TAddress WHERE AddressId = @AddressId

  DELETE FROM TAddressStore WHERE AddressStoreId IN (SELECT AddressStoreId FROM TAddress WHERE AddressId = @AddressId)

  SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
