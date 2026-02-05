SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE dbo.[SpCustomDeleteAddressStoreWithMatching] @StampUser VARCHAR (255), 
                                             @IndigoClientId BIGINT,
											 @AddressStoreId BIGINT, 
											 @CRMContactId	 BIGINT
AS 

SET NOCOUNT ON
    DECLARE @isAddressStoreUsedByAnotherCrmContact INT
  BEGIN 
      SET @isAddressStoreUsedByAnotherCrmContact = dbo.FnIsAddressStoreUsedByAnotherCrmContact(@IndigoClientId, @CRMContactId, @AddressStoreId)

	  IF(@isAddressStoreUsedByAnotherCrmContact = 0)
	  BEGIN
		  DELETE FROM crm..TAddressStore
		  OUTPUT deleted.[IndClientId]
		  ,deleted.[AddressLine1]
		  ,deleted.[AddressLine2]
		  ,deleted.[AddressLine3]
		  ,deleted.[AddressLine4]
		  ,deleted.[CityTown]
		  ,deleted.[RefCountyId]
		  ,deleted.[Postcode]
		  ,deleted.[Extensible]
		  ,deleted.[PostCodeX]
		  ,deleted.[PostCodeY]
		  ,deleted.[RefCountryId]
		  ,deleted.[ConcurrencyId]
		  ,deleted.[AddressStoreId]
		  ,'D'
		  ,GETDATE()
		  ,@StampUser
		  ,deleted.[PostCodeLatitudeX]
		  ,deleted.[PostCodeLongitudeY]
		  INTO CRM..TAddressStoreAudit([IndClientId]
		  ,[AddressLine1]
		  ,[AddressLine2]
		  ,[AddressLine3]
		  ,[AddressLine4]
		  ,[CityTown]
		  ,[RefCountyId]
		  ,[Postcode]
		  ,[Extensible]
		  ,[PostCodeX]
		  ,[PostCodeY]
		  ,[RefCountryId]
		  ,[ConcurrencyId]
		  ,[AddressStoreId]
		  ,[StampAction]
		  ,[StampDateTime]
		  ,[StampUser]
		  ,[PostCodeLatitudeX]
		  ,[PostCodeLongitudeY])	  
		  WHERE AddressStoreId = @addressStoreId AND IndClientId = @IndigoClientId
		  --UNLINK RELATED ENTITIES FROM THE ADDRESS STORE
		  EXEC factfind.dbo.SpCustomRemovePropertyDetail @StampUser, @IndigoClientId, @addressStoreId		
	  END	    	  		  
	EXEC factfind.dbo.SpCustomRelinkAddressStoreFromManualRecommendation @StampUser, @IndigoClientId, @AddressStoreId, NULL, @CRMContactId
	EXEC policymanagement.dbo.SpCustomRelinkAddressStoreFromMortgage @StampUser, @IndigoClientId, @AddressStoreId, NULL, @CRMContactId		  
	EXEC policymanagement.dbo.SpCustomRelinkAddressStoreFromEquityRelease @StampUser, @IndigoClientId, @AddressStoreId, NULL, @CRMContactId
  END