SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpDeleteAddressById]
	@AddressId Bigint,
	@StampUser varchar (255)
	
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
		'D',
    		GetDate(),
    		@StampUser 
	FROM TAddress T1	
	WHERE T1.AddressId = @AddressId

	DELETE T1 FROM TAddress T1
	WHERE T1.AddressId = @AddressId

	SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
