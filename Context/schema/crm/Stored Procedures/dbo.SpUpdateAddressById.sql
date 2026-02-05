SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpUpdateAddressById]
@KeyAddressId bigint,
@StampUser varchar (255),
@IndClientId bigint,
@CRMContactId bigint = NULL,
@AddressStoreId bigint = NULL,
@RefAddressTypeId bigint = 0,
@AddressTypeName varchar (50) = NULL,
@DefaultFg tinyint,
@RefAddressStatusId bigint,
@ResidentFromDate datetime
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TAddressAudit (
    IndClientId, 
    CRMContactId, 
    AddressStoreId, 
    RefAddressTypeId, 
    AddressTypeName, 
    DefaultFg, 
    RefAddressStatusId, 
    ResidentFromDate, 
    ConcurrencyId,
    AddressId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.IndClientId, 
    T1.CRMContactId, 
    T1.AddressStoreId, 
    T1.RefAddressTypeId, 
    T1.AddressTypeName, 
    T1.DefaultFg, 
    T1.RefAddressStatusId, 
    T1.ResidentFromDate, 
    T1.ConcurrencyId,
    T1.AddressId,
    'U',
    GetDate(),
    @StampUser

  FROM TAddress T1

  WHERE (T1.AddressId = @KeyAddressId)
  UPDATE T1
  SET 
    T1.IndClientId = @IndClientId,
    T1.CRMContactId = @CRMContactId,
    T1.AddressStoreId = @AddressStoreId,
    T1.RefAddressTypeId = @RefAddressTypeId,
    T1.AddressTypeName = @AddressTypeName,
    T1.DefaultFg = @DefaultFg,
    T1.RefAddressStatusId = @RefAddressStatusId,
    T1.ResidentFromDate = @ResidentFromDate,
    T1.ConcurrencyId = T1.ConcurrencyId + 1
  FROM TAddress T1

  WHERE (T1.AddressId = @KeyAddressId)

SELECT * FROM TAddress [Address]
  WHERE ([Address].AddressId = @KeyAddressId)
 FOR XML AUTO

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
