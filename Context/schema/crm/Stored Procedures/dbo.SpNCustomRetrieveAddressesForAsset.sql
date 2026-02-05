SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAddressesForAsset] 
		@IndClientId bigint,
		@CRMContactId1 bigint,
		@CRMContactId2 bigint,
		@AssetId bigint
AS
	SELECT 
		1 AS TAG,
	    NULL AS Parent, 
		address.AddressId AS [Address!1!AddressId],
		ISNULL(store.AddressLine1,'') AS [Address!1!AddressLine1]
	FROM crm..TAddress address
		INNER JOIN crm..TAddressStore store ON store.AddressStoreId = address.AddressStoreId
		LEFT JOIN factfind..TAssets assets ON assets.AddressId = address.AddressId
	WHERE address.IndClientId = @IndClientId AND address.CRMContactId IN (@CRMContactId1, @CrmContactId2) AND (assets.AddressId IS NULL OR assets.AssetsId = @AssetId)
	ORDER BY store.AddressLine1
FOR XML EXPLICIT  