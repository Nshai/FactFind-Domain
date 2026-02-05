SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPropertytobeMortgaged]
	@StampUser varchar (255),
	@PropertytobeMortgagedId bigint,
	@StampAction char(1)
AS

INSERT INTO TPropertytobeMortgagedAudit 
( CRMContactId, SelectAddress, AddressLine1, AddressLine2, 
		AddressLine3, AddressLine4, CityTown, County, 
		Country, PostCode, HouseType, PropertyType, 
		TenureType, PropertyStatus, PropertyStatusOther, Construction, 
		PropertyExtended, YearBuilt, GroundRent, ServiceCharge, 
		Bedrooms, DiningRooms, AdditionalRooms, Kitchens, 
		Bathrooms, Toilets, numfloors, SingleGarages, 
		DoubleGarages, Conservatory, BrickStone, TileSlate, 
		SelfBuild, Commercial, AgriculturalTie, FloorInBlock, 
		FlatsInBlock, Walls, Roof, LinktoAsset, 
		Linktoliability, ConcurrencyId, 
	PropertytobeMortgagedId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, SelectAddress, AddressLine1, AddressLine2, 
		AddressLine3, AddressLine4, CityTown, County, 
		Country, PostCode, HouseType, PropertyType, 
		TenureType, PropertyStatus, PropertyStatusOther, Construction, 
		PropertyExtended, YearBuilt, GroundRent, ServiceCharge, 
		Bedrooms, DiningRooms, AdditionalRooms, Kitchens, 
		Bathrooms, Toilets, numfloors, SingleGarages, 
		DoubleGarages, Conservatory, BrickStone, TileSlate, 
		SelfBuild, Commercial, AgriculturalTie, FloorInBlock, 
		FlatsInBlock, Walls, Roof, LinktoAsset, 
		Linktoliability, ConcurrencyId, 
	PropertytobeMortgagedId, @StampAction, GetDate(), @StampUser
FROM TPropertytobeMortgaged
WHERE PropertytobeMortgagedId = @PropertytobeMortgagedId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
