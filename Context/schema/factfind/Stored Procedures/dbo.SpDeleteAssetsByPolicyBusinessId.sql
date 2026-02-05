SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpDeleteAssetsByPolicyBusinessId]
@PolicyBusinessId bigint,
@StampUser varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TAssetsAudit (
    CRMContactId, 
    CRMContactId2, 
    Owner, 
    Description, 
    Amount, 
    ValuedOn, 
    PriceUpdatedByUser, 
    Type, 
    PurchasePrice, 
    PurchasedOn, 
    loanamount, 
    investmentprop, 
    PolicyBusinessId, 
    AssetCategoryId, 
    percentOwnership, 
    RelatedtoAddress, 
    ConcurrencyId,
    AssetsId,
	IsVisibleToClient,
    StampAction,
    StampDateTime,
    StampUser,
	percentOwnershipCrmContact2, 
	AddressLine2, 
	AddressLine3, 
	AddressLine4, 
	AddressCityTown, 
	AddressPostCode, 
	RefCountyId, 
	RefCountryId)
  SELECT
    T1.CRMContactId, 
    T1.CRMContactId2, 
    T1.Owner, 
    T1.Description, 
    T1.Amount, 
    T1.ValuedOn, 
    T1.PriceUpdatedByUser, 
    T1.Type, 
    T1.PurchasePrice, 
    T1.PurchasedOn, 
    T1.loanamount, 
    T1.investmentprop, 
    T1.PolicyBusinessId, 
    T1.AssetCategoryId, 
    T1.percentOwnership, 
    T1.RelatedtoAddress, 
    T1.ConcurrencyId,
    T1.AssetsId,
	T1.IsVisibleToClient,
    'D',
    GetDate(),
    @StampUser,
	T1.percentOwnershipCrmContact2, 
	T1.AddressLine2, 
	T1.AddressLine3, 
	T1.AddressLine4, 
	T1.AddressCityTown, 
	T1.AddressPostCode, 
	T1.RefCountyId, 
	T1.RefCountryId

  FROM TAssets T1

  WHERE (T1.PolicyBusinessId = @PolicyBusinessId)
  DELETE T1 FROM TAssets T1

  WHERE (T1.PolicyBusinessId = @PolicyBusinessId)


  SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
