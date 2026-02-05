SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCustomCreateAddressStoreWithMatching]
@StampUser varchar (255),
@IndClientId bigint,
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

DECLARE @matchedAddressStore BIGINT

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

	SET @matchedAddressStore = dbo.FnGetFirstMatchedAddressStore(@IndClientId, 
                               @AddressLine1, @AddressLine2, @AddressLine3, 
                               @AddressLine4, @PostCode, @CityTown, @RefCountryId, @RefCountyId) 


      IF( @matchedAddressStore IS NOT NULL ) 
	  BEGIN
          UPDATE crm..TAddressStore 
          SET RefCountryId = (CASE WHEN (ISNULL(RefCountryId, '') = '') AND (ISNULL(@RefCountryId, '') != '')
              THEN @RefCountryId
              ELSE RefCountryId END),
          RefCountyId = (CASE WHEN (ISNULL(RefCountyId, '') = '') AND (ISNULL(@RefCountyId, '') != '')
              THEN @RefCountyId
              ELSE RefCountyId END)
          OUTPUT deleted.AddressLine1,
              deleted.AddressLine2,
              deleted.AddressLine3,
              deleted.AddressLine4,
              deleted.AddressStoreId,
              deleted.CityTown,
              deleted.ConcurrencyId,
              deleted.Extensible,
              deleted.IndClientId,
              deleted.MigrationRef,
              deleted.Postcode,
              deleted.PostCodeLatitudeX,
              deleted.PostCodeLongitudeY,
              deleted.PostCodeX,
              deleted.PostCodeY,
              deleted.RefCountryId,
              deleted.RefCountyId,
              @StampUser,
              GETDATE(),
              'U'
          INTO TAddressStoreAudit(
              AddressLine1,
              AddressLine2,
              AddressLine3,
              AddressLine4,
              AddressStoreId,
              CityTown,
              ConcurrencyId,
              Extensible,
              IndClientId,
              MigrationRef,
              Postcode,
              PostCodeLatitudeX,
              PostCodeLongitudeY,
              PostCodeX,
              PostCodeY,
              RefCountryId,
              RefCountyId,
              StampUser,
              StampDateTime,
              StampAction)
          WHERE AddressStoreId = @matchedAddressStore
          AND (((ISNULL(RefCountryId, '') = '') AND (ISNULL(@RefCountryId, '') != '')) OR 
          ((ISNULL(RefCountyId, '') = '') AND (ISNULL(@RefCountyId, '') != '')))

        SELECT @matchedAddressStore
        RETURN @matchedAddressStore
	  END
      ELSE 
        BEGIN 
			
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
            VALUES      (@AddressLine1, 
                         @AddressLine2, 
                         @AddressLine3, 
                         @AddressLine4, 
                         @PostCode, 
                         @CityTown, 
                         @RefCountryId, 
                         @RefCountyId, 
                         @IndClientId,
						 1) 
			SELECT @matchedAddressStore = Scope_identity() 
			EXEC SpNAuditAddressStore @StampUser, @matchedAddressStore, 'C'
            SELECT @matchedAddressStore
			RETURN @matchedAddressStore
        END 

END
GO
