SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAddressesByIds] 
		@IndClientId bigint,
		@AddressIds varchar(max)
AS
	SELECT 
		1 AS TAG,
		NULL AS Parent, 
		address.AddressId AS [Address!1!AddressId],
		ISNULL(store.AddressLine1,'') AS [Address!1!AddressLine1]
	FROM crm..TAddress address
		 INNER JOIN crm..TAddressStore store ON store.AddressStoreId = address.AddressStoreId
	WHERE address.IndClientId = @IndClientId AND address.AddressId IN (SELECT value FROM STRING_SPLIT(@AddressIds, ',') WHERE RTRIM(value) <> '')
	ORDER BY store.AddressLine1
	FOR XML EXPLICIT
	
