SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- ***************************************************************************
-- This is a temporary stored procedure for Asset API backward compatibility *
-- ***************************************************************************
CREATE PROCEDURE [dbo].[SpGetFirstMatchedAssetAddress]
@StampUser varchar (255),
@IndClientId bigint,
@CrmContactId bigint,
@CrmContactId2 bigint = NULL,
@AddressLine1 varchar (1000) = NULL,
@AddressLine2 varchar (1000) = NULL,
@AddressLine3 varchar (1000) = NULL,
@AddressLine4 varchar (1000) = NULL,
@CityTown varchar (255) = NULL,
@RefCountyId bigint = NULL,
@Postcode varchar (20) = NULL,
@RefCountryId bigint = NULL
AS

SET NOCOUNT ON

DECLARE @matchedAddress BIGINT,
        @matchedAddressStore BIGINT

BEGIN
	SET @AddressLine1 = crm.dbo.FnRemoveExtraSpaces(@AddressLine1)
	IF(ISNULL(@AddressLine2, '') != '')
		SET @AddressLine2 = crm.dbo.FnRemoveExtraSpaces(@AddressLine2)
	IF(ISNULL(@AddressLine3, '') != '')
		SET @AddressLine3 = crm.dbo.FnRemoveExtraSpaces(@AddressLine3)
	IF(ISNULL(@AddressLine4, '') != '')
		SET @AddressLine4 = crm.dbo.FnRemoveExtraSpaces(@AddressLine4)
	IF(ISNULL(@Postcode, '') != '')
		SET @Postcode = crm.dbo.FnRemoveExtraSpaces(@Postcode)
	IF(ISNULL(@CityTown, '') != '')
		SET @CityTown = crm.dbo.FnRemoveExtraSpaces(@CityTown)

	SET @matchedAddressStore = crm.dbo.FnGetFirstMatchedAddressStore(@IndClientId, 
                               @AddressLine1, @AddressLine2, @AddressLine3, 
                               @AddressLine4, @PostCode, @CityTown, @RefCountryId, @RefCountyId) 

		IF( @matchedAddressStore IS NOT NULL ) 
		BEGIN
			SELECT DISTINCT AddressId 
			INTO #assetAddresses
			FROM factfind..TAssets
			WHERE (CRMContactId = @CrmContactId OR CRMContactId2 = @CrmContactId OR CRMContactId = @CrmContactId2 OR CRMContactId2 = @CrmContactId2) AND AddressId IS NOT NULL
		
			SELECT TOP(1) @matchedAddress = a.AddressId 
			FROM crm..TAddress a
			WHERE a.AddressStoreId = @matchedAddressStore AND a.IndClientId = @IndClientId AND (a.CRMContactId = @CrmContactId OR a.CRMContactId = @CrmContactId2)
					AND NOT EXISTS (SELECT 1 FROM #assetAddresses WHERE AddressId = A.AddressId)
			ORDER BY
				CASE a.CRMContactId 
				WHEN @CrmContactId THEN 1
				ELSE 2
			END,
				CASE a.RefAddressTypeId 
				WHEN 3 THEN 1 -- Other type
				ELSE 2
			END, a.AddressId
	 	
			IF( @matchedAddress IS NOT NULL ) 
				SELECT @matchedAddress
		END 

	RETURN (0)

END
