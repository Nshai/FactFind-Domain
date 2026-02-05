SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE dbo.[SpCustomUpdateAddressStoreWithMatching] @StampUser      VARCHAR (255), 
                                             @IndigoClientId BIGINT,
											 @AddressStoreId BIGINT, 
											 @CRMContactId	 BIGINT,
                                             @AddressLine1   VARCHAR(1000), 
                                             @AddressLine2   VARCHAR(1000), 
                                             @AddressLine3   VARCHAR(1000), 
                                             @AddressLine4   VARCHAR(1000), 
                                             @PostCode       VARCHAR(20), 
                                             @CityTown       VARCHAR(255), 
                                             @RefCountry     BIGINT, 
                                             @RefCounty      BIGINT 
AS 

SET NOCOUNT ON

DECLARE @matchedAddressStore BIGINT,
		@isAddressStoreUsedByAnotherCrmContact INT,
		@PreviousAddressStoreId BIGINT = null,
		@isNotDifferentCase BIT = 0
BEGIN 
	SET @AddressLine1 = dbo.FnRemoveExtraSpaces(@AddressLine1)
	IF(ISNULL(@AddressLine2, '') != '')
		SET @AddressLine2 = dbo.FnRemoveExtraSpaces(@AddressLine2)
	IF(ISNULL(@AddressLine3, '') != '')
		SET @AddressLine3 = dbo.FnRemoveExtraSpaces(@AddressLine3)
	IF(ISNULL(@AddressLine4, '') != '')
		SET @AddressLine4 = dbo.FnRemoveExtraSpaces(@AddressLine4)
	IF(ISNULL(@Postcode, '') != '')
		SET @Postcode = dbo.FnRemoveExtraSpaces(@Postcode)
	IF(ISNULL(@CityTown, '') != '')
		SET @CityTown = dbo.FnRemoveExtraSpaces(@CityTown)

	SET @matchedAddressStore = dbo.FnGetFirstMatchedAddressStore(@IndigoClientId, 
                               @AddressLine1, @AddressLine2, @AddressLine3, 
                               @AddressLine4, @PostCode, @CityTown, @RefCountry, @RefCounty) 
	SET @isAddressStoreUsedByAnotherCrmContact = dbo.FnIsAddressStoreUsedByAnotherCrmContact(@IndigoClientId, @CRMContactId, @AddressStoreId)

	IF(@matchedAddressStore = @AddressStoreId)
	BEGIN 
		IF (SELECT 1
		FROM CRM.dbo.TAddressStore
		WHERE AddressStoreId = @matchedAddressStore AND
			AddressLine1 = @AddressLine1 COLLATE SQL_Latin1_General_CP1_CS_AS AND
			AddressLine2 = @AddressLine2 COLLATE SQL_Latin1_General_CP1_CS_AS AND
			AddressLine3 = @AddressLine3 COLLATE SQL_Latin1_General_CP1_CS_AS AND 
			AddressLine4 = @AddressLine4 COLLATE SQL_Latin1_General_CP1_CS_AS AND
			PostCode = @PostCode COLLATE SQL_Latin1_General_CP1_CS_AS AND
			CityTown = @CityTown COLLATE SQL_Latin1_General_CP1_CS_AS) IS NOT NULL
		SET @isNotDifferentCase = 1	

		UPDATE crm..TAddressStore 
		SET RefCountryId = (CASE WHEN (ISNULL(RefCountryId, '') = '') AND (ISNULL(@RefCountry, '') != '') 
									THEN @RefCountry 
									ELSE RefCountryId END),
		RefCountyId = (CASE WHEN (ISNULL(RefCountyId, '') = '') AND (ISNULL(@RefCounty, '') != '') 
						THEN @RefCounty 
						ELSE RefCountyId END),
		CityTown = @CityTown,
		AddressLine1 = @AddressLine1,
		AddressLine2 = @AddressLine2,
		AddressLine3 = @AddressLine3,
		AddressLine4 = @AddressLine4,
		PostCode = @PostCode
		OUTPUT deleted.AddressStoreId, 
			deleted.AddressLine1, 
			deleted.AddressLine2, 
			deleted.AddressLine3, 
			deleted.AddressLine4, 
			deleted.CityTown, 
			deleted.IndClientId, 
			deleted.Postcode, 
			deleted.RefCountryId, 
			deleted.RefCountyId, 
			deleted.ConcurrencyId,
			@StampUser, 
			Getdate(), 
			'U' 
		INTO TAddressStoreAudit(AddressStoreId, AddressLine1, AddressLine2, 
		AddressLine3, AddressLine4, CityTown, IndClientId, Postcode, RefCountryId, 
		RefCountyId, ConcurrencyId, StampUser, StampDateTime, StampAction) 
		WHERE AddressStoreId = @AddressStoreId
		AND (((ISNULL(RefCountryId, '') = '') AND (ISNULL(@RefCountry, '') != '')) OR 
		((ISNULL(RefCountyId, '') = '') AND (ISNULL(@RefCounty, '') != '')) OR 
		((ISNULL(CityTown, '') = '') AND (ISNULL(@CityTown, '') != '')) OR 
		@isAddressStoreUsedByAnotherCrmContact = 0 OR
		@isNotDifferentCase = 0)
		SELECT @AddressStoreId
		RETURN @AddressStoreId
	END


	IF( @matchedAddressStore IS NOT NULL ) 
	BEGIN
		IF(@isAddressStoreUsedByAnotherCrmContact = 0)
		BEGIN
			DELETE FROM CRM..TAddressStore
			OUTPUT deleted.AddressStoreId, 
			deleted.AddressLine1, 
			deleted.AddressLine2, 
			deleted.AddressLine3, 
			deleted.AddressLine4, 
			deleted.CityTown, 
			deleted.IndClientId, 
			deleted.Postcode, 
			deleted.RefCountryId, 
			deleted.RefCountyId, 
			deleted.ConcurrencyId,
			@StampUser, 
			Getdate(), 
			'D'
			INTO TAddressStoreAudit(AddressStoreId, AddressLine1, AddressLine2, 
			AddressLine3, AddressLine4, CityTown, IndClientId, Postcode, RefCountryId, 
			RefCountyId, ConcurrencyId, StampUser, StampDateTime, StampAction) 
			WHERE AddressStoreId = @AddressStoreId
			EXEC factfind.dbo.SpCustomRemovePropertyDetail @StampUser, @IndigoClientId, @addressStoreId	
		END
		  	  	  		  
		EXEC factfind.dbo.SpCustomRelinkAddressStoreFromManualRecommendation @StampUser, @IndigoClientId, @AddressStoreId, @matchedAddressStore, @CRMContactId
		EXEC policymanagement.dbo.SpCustomRelinkAddressStoreFromMortgage @StampUser, @IndigoClientId, @AddressStoreId, @matchedAddressStore, @CRMContactId		  
		EXEC policymanagement.dbo.SpCustomRelinkAddressStoreFromEquityRelease @StampUser, @IndigoClientId, @AddressStoreId, @matchedAddressStore, @CRMContactId
			
		SELECT @matchedAddressStore 
		RETURN @matchedAddressStore
	END
	ELSE 
	BEGIN 
		IF(@isAddressStoreUsedByAnotherCrmContact = 0)
		BEGIN
			UPDATE CRM..TAddressStore
			SET AddressLine1 = @AddressLine1,
			AddressLine2 = @AddressLine2,
			AddressLine3 = @AddressLine3,
			AddressLine4 = @AddressLine4,
			Postcode = @PostCode,
			CityTown = @CityTown,
			RefCountryId = @RefCountry,
			RefCountyId = @RefCounty,
			IndClientId = @IndigoClientId
			OUTPUT deleted.AddressStoreId, 
			deleted.AddressLine1, 
			deleted.AddressLine2, 
			deleted.AddressLine3, 
			deleted.AddressLine4, 
			deleted.CityTown, 
			deleted.IndClientId, 
			deleted.Postcode, 
			deleted.RefCountryId, 
			deleted.RefCountyId, 
			@StampUser, 
			Getdate(), 
			'U',
			deleted.ConcurrencyId
			INTO TAddressStoreAudit(AddressStoreId, AddressLine1, AddressLine2, 
			AddressLine3, AddressLine4, CityTown, IndClientId, Postcode, RefCountryId, 
			RefCountyId, StampUser, StampDateTime, StampAction, ConcurrencyId) 
			WHERE AddressStoreId = @AddressStoreId
		END
		IF(@isAddressStoreUsedByAnotherCrmContact = 1)
		BEGIN
			SET @PreviousAddressStoreId = @AddressStoreId
			INSERT INTO crm..TAddressStore
			(AddressLine1, 
			AddressLine2, 
			AddressLine3, 
			AddressLine4, 
			Postcode, 
			CityTown, 
			RefCountryId, 
			RefCountyId, 
			IndClientId,
			ConcurrencyId)
			VALUES (@AddressLine1, 
			@AddressLine2, 
			@AddressLine3, 
			@AddressLine4, 
			@PostCode, 
			@CityTown, 
			@RefCountry, 
			@RefCounty, 
			@IndigoClientId,
			1) 
			SELECT @AddressStoreId = Scope_identity() 
			EXEC SpNAuditAddressStore @StampUser, @AddressStoreId, 'C'
			EXEC factfind.dbo.SpCustomRelinkAddressStoreFromManualRecommendation @StampUser, @IndigoClientId, @PreviousAddressStoreId, @AddressStoreId, @CRMContactId
			EXEC policymanagement.dbo.SpCustomRelinkAddressStoreFromMortgage @StampUser, @IndigoClientId, @PreviousAddressStoreId, @AddressStoreId, @CRMContactId		  
			EXEC policymanagement.dbo.SpCustomRelinkAddressStoreFromEquityRelease @StampUser, @IndigoClientId, @PreviousAddressStoreId, @AddressStoreId, @CRMContactId
		END
		SELECT @AddressStoreId
		RETURN @AddressStoreId
	END 
END