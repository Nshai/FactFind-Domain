SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateContactAddress]
@StampUser varchar (255),
@ContactId bigint,
@AddressId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @ContactAddressId bigint

  INSERT INTO TContactAddress (
    ContactId, 
    AddressId, 
    ConcurrencyId ) 
  VALUES (
    @ContactId, 
    @AddressId, 
    1) 

  SELECT @ContactAddressId = SCOPE_IDENTITY()
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
    'C',
    GetDate(),
    @StampUser

  FROM TContactAddress T1
 WHERE T1.ContactAddressId=@ContactAddressId
  EXEC SpRetrieveContactAddressById @ContactAddressId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
