SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAddressStore]
	@StampUser varchar (255),
	@AddressStoreId bigint,
	@StampAction char(1)
AS

INSERT INTO TAddressStoreAudit 
( IndClientId, AddressLine1, AddressLine2, AddressLine3, 
		AddressLine4, CityTown, RefCountyId, Postcode, 
		RefCountryId, PostCodeX, PostCodeY, PostCodeLatitudeX,PostCodeLongitudeY,
		ConcurrencyId, AddressStoreId, StampAction, StampDateTime, StampUser) 
Select IndClientId, AddressLine1, AddressLine2, AddressLine3, 
		AddressLine4, CityTown, RefCountyId, Postcode, 
		RefCountryId, PostCodeX, PostCodeY, PostCodeLatitudeX,PostCodeLongitudeY,
		ConcurrencyId, AddressStoreId, @StampAction, GetDate(), @StampUser
FROM TAddressStore
WHERE AddressStoreId = @AddressStoreId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
