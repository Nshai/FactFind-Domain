SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAssets]
	@StampUser varchar (255),
	@AssetsId bigint,
	@StampAction char(1)
AS

INSERT INTO TAssetsAudit (
		CRMContactId, CRMContactId2, [Owner], [Description], 
		Amount, ValuedOn, PriceUpdatedByUser, [Type], 
		PurchasePrice, PurchasedOn, loanamount, investmentprop, 
		PolicyBusinessId, AssetCategoryId, percentOwnership, RelatedtoAddress, 
		ConcurrencyId, AssetsId, IsVisibleToClient, WhoCreatedUserId, AssetMigrationRef,
		StampAction, StampDateTime, StampUser,
		percentOwnershipCRMContact2, AddressLine2, AddressLine3, AddressLine4, 
		AddressCityTown, AddressPostCode, RefCountyId, RefCountryId, IncomeId, IsHolding, [CurrencyCode], AddressId,
		CrystallisationStatus, CrystallisedPercentage, UncrystallisedPercentage) 
SELECT CRMContactId, CRMContactId2, [Owner], [Description], 
		Amount, ValuedOn, PriceUpdatedByUser, [Type], 
		PurchasePrice, PurchasedOn, loanamount, investmentprop, 
		PolicyBusinessId, AssetCategoryId, percentOwnership, RelatedtoAddress, 
		ConcurrencyId, AssetsId, IsVisibleToClient, WhoCreatedUserId, AssetMigrationRef,
		@StampAction, GetDate(), @StampUser,
		percentOwnershipCRMContact2, AddressLine2, AddressLine3, AddressLine4, 
		AddressCityTown, AddressPostCode, RefCountyId, RefCountryId, IncomeId, IsHolding, [CurrencyCode], AddressId,
		CrystallisationStatus, CrystallisedPercentage, UncrystallisedPercentage
FROM TAssets
WHERE AssetsId = @AssetsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
