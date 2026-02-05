SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrieveAllAddressesForCRMContact1And2] 
		@IndClientId bigint,
		@CRMContactId1 bigint,
		@CRMContactId2 bigint
AS
	SELECT 
		1 AS TAG,
		NULL AS Parent, 
		address.AddressId AS [Address!1!AddressId],
		ISNULL(store.AddressLine1,'') AS [Address!1!AddressLine1]
	FROM crm..TAddress address
			INNER JOIN crm..TAddressStore store ON store.AddressStoreId = address.AddressStoreId
	WHERE address.IndClientId = @IndClientId AND address.CRMContactId IN (@CRMContactId1, @CRMContactId2)
	ORDER BY store.AddressLine1
	FOR XML EXPLICIT
