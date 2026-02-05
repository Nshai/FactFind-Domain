SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Description: This function returns matched address from TAddressStore
-- =============================================
CREATE FUNCTION [dbo].[FnGetFirstMatchedAddressStore]
(
	@IndigoClientId bigint,
	@AddressLine1 varchar(1000),
	@AddressLine2 varchar(1000),
	@AddressLine3 varchar(1000),
	@AddressLine4 varchar(1000),
	@PostCode varchar(20),
	@CityTown varchar(255),
	@RefCountry bigint,
	@RefCounty bigint
)  
RETURNS bigint
AS  
BEGIN
DECLARE @AddressStoreId bigint
BEGIN	
	IF(@PostCode IS NULL OR @PostCode = '')
	BEGIN
		SELECT TOP 1 @AddressStoreId = AddressStoreId FROM crm..TAddressStore 
		WHERE IndClientId = @IndigoClientId
		AND (Postcode IS NULL OR Postcode = '')
		AND AddressLine1 = @AddressLine1
		AND ISNULL(AddressLine2, '')  = ISNULL(@AddressLine2, '') 
		AND ISNULL(AddressLine3, '')  = ISNULL(@AddressLine3, '') 
		AND ISNULL(AddressLine4, '')  = ISNULL(@AddressLine4, '') 
		AND ISNULL(CityTown, '') = ISNULL(@CityTown, '')
		AND (ISNULL(RefCountryId, '') = '' or RefCountryId = @RefCountry)
		AND (ISNULL(RefCountyId, '') = '' or RefCountyId = @RefCounty)
		ORDER BY AddressStoreId
	END
	ELSE
	BEGIN
		SELECT TOP 1 @AddressStoreId = AddressStoreId FROM crm..TAddressStore 
		WHERE IndClientId = @IndigoClientId
		AND Postcode = @PostCode
		AND AddressLine1 = @AddressLine1
		AND ISNULL(AddressLine2, '')  = ISNULL(@AddressLine2, '') 
		AND ISNULL(AddressLine3, '')  = ISNULL(@AddressLine3, '') 
		AND ISNULL(AddressLine4, '')  = ISNULL(@AddressLine4, '') 
		AND ISNULL(CityTown, '') = ISNULL(@CityTown, '')
		AND (ISNULL(RefCountryId, '') = '' or RefCountryId = @RefCountry)
		AND (ISNULL(RefCountyId, '') = '' or RefCountyId = @RefCounty)
		ORDER BY AddressStoreId
	END 		
	RETURN @AddressStoreId
END
END
GO