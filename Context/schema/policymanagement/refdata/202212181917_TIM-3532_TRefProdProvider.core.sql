USE PolicyManagement;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
    , @Comments VARCHAR(255)
    , @ErrorMessage VARCHAR(MAX)
    , @StampAction CHAR(1) = 'C'
	, @StampDateTime AS DATETIME = GETUTCDATE()
	, @StampUser AS VARCHAR(255) = '0'
	, @lastRefLicenseTypeToRefProdProviderId INT
	
SELECT @ScriptGUID = 'a95d05f4-6e98-4629-aaa7-6523276d472e'
    , @Comments = 'TIM-3532 add unknown provider to the list of product providers in US'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY
    BEGIN TRANSACTION

        BEGIN TRY
            BEGIN
				Declare @CorporateId as INT;
				Declare @ClientId as INT;
				Declare @RefProdProviderId as INT;
				declare @UnkownProvider as VARCHAR(255) = N'Unknown Provider';	
				
				-- TCorporate
				insert into  crm..TCorporate (IndClientId,CorporateName,RefCorporateTypeId)
				Values(0,@UnkownProvider,1)

				set @CorporateId = (select top 1  CorporateId from crm..TCorporate where CorporateName=@UnkownProvider Order By CorporateId desc)

				-- TCorporateAudit
				INSERT INTO crm..TCorporateAudit  
					  ([IndClientId],[CorporateName],[ArchiveFG],[BusinessType],[RefCorporateTypeId],[CompanyRegNo],[EstIncorpDate],[YearEnd],[VatRegFg]
					  ,[Extensible],[VatRegNo],[ConcurrencyId],[CorporateId],[StampAction],[StampDateTime],[StampUser],[MigrationRef],[LEI],[LEIExpiryDate])
				SELECT [IndClientId],[CorporateName],[ArchiveFG],[BusinessType],[RefCorporateTypeId],[CompanyRegNo],[EstIncorpDate],[YearEnd],[VatRegFg]
					  ,[Extensible],[VatRegNo],[ConcurrencyId],[CorporateId],@StampAction, @StampDateTime, @StampUser,[MigrationRef],[LEI],[LEIExpiryDate]
				FROM  crm..TCorporate
				WHERE CorporateId =@CorporateId

				-- TCRMContact
				insert into crm..TCRMContact(CorporateId,CorporateName,IndClientId) 
				values(@CorporateId,@UnkownProvider,0)

				set @ClientId = (select CRMContactId from crm..TCRMContact where CorporateId=@CorporateId)

				-- TCRMContactAudit
				INSERT INTO crm..TCRMContactAudit
				([RefCRMContactStatusId],[PersonId],[CorporateId],[TrustId],[AdvisorRef],[RefSourceOfClientId],[SourceValue],[Notes],[ArchiveFg],[LastName]
					  ,[FirstName],[CorporateName],[DOB],[Postcode],[OriginalAdviserCRMId],[CurrentAdviserCRMId],[CurrentAdviserName],[CRMContactType],[IndClientId]
					  ,[FactFindId],[InternalContactFG],[RefServiceStatusId],[AdviserAssignedByUserId],[_ParentId],[_ParentTable],[_ParentDb],[_OwnerId],[MigrationRef]
					  ,[CreatedDate],[ExternalReference],[AdditionalRef],[CampaignDataId],[FeeModelId],[ConcurrencyId],[CRMContactId],[StampAction],[StampDateTime],[StampUser]
					  ,[ServiceStatusStartDate],[ClientTypeId],[IsHeadOfFamilyGroup],[FamilyGroupCreationDate],[IsDeleted])
				SELECT 
				[RefCRMContactStatusId],[PersonId],[CorporateId],[TrustId],[AdvisorRef],[RefSourceOfClientId],[SourceValue],[Notes],[ArchiveFg],[LastName]
					  ,[FirstName],[CorporateName],[DOB],[Postcode],[OriginalAdviserCRMId],[CurrentAdviserCRMId],[CurrentAdviserName],[CRMContactType],[IndClientId]
					  ,[FactFindId],[InternalContactFG],[RefServiceStatusId],[AdviserAssignedByUserId],[_ParentId],[_ParentTable],[_ParentDb],[_OwnerId],[MigrationRef]
					  ,[CreatedDate],[ExternalReference],[AdditionalRef],[CampaignDataId],[FeeModelId],[ConcurrencyId],[CRMContactId],@StampAction,@StampDateTime,@StampUser
					  ,[ServiceStatusStartDate],[ClientTypeId],[IsHeadOfFamilyGroup],[FamilyGroupCreationDate],[IsDeleted]
				FROM crm..TCRMContact
				WHERE CRMContactId =@ClientId 
					
				-- TRefProdProvider			
				insert into PolicyManagement..TRefProdProvider(CRMContactId,RetireFg,ConcurrencyId,IsTransactionFeedSupported,IsConsumerFriendly,RegionCode,IsBankAccountTransactionFeed)
				values (@ClientId,0,1,0,0,'US',0)
				set @RefProdProviderId = (select RefProdProviderId from PolicyManagement..TRefProdProvider where CRMContactId = @ClientId and RegionCode='US')

				-- TRefProdProviderAudit
				INSERT INTO TRefProdProviderAudit
				([CRMContactId],[FundProviderId],[NewProdProviderId],[RetireFg],[ConcurrencyId],[RefProdProviderId],[StampAction],[StampDateTime],[StampUser],[IsTransactionFeedSupported]
					  ,[IsConsumerFriendly],[RegionCode],[IsBankAccountTransactionFeed])
				SELECT 
				[CRMContactId],[FundProviderId],[NewProdProviderId],[RetireFg],[ConcurrencyId],[RefProdProviderId] ,@StampAction,@StampDateTime,@StampUser,[IsTransactionFeedSupported]
					  ,[IsConsumerFriendly],[RegionCode],[IsBankAccountTransactionFeed]
				FROM TRefProdProvider
				WHERE RefProdProviderId =@RefProdProviderId
				
				-- TRefLicenseTypeToRefProdProvider
				insert into PolicyManagement..TRefLicenseTypeToRefProdProvider(RefLicenseTypeId,RefProdproviderId,ConcurrencyId)
				VALUES(1,@RefProdProviderId,1)
				
				 SELECT @lastRefLicenseTypeToRefProdProviderId = SCOPE_IDENTITY()
				 -- TRefLicenseTypeToRefProdProviderAudit
				INSERT INTO policymanagement..TRefLicenseTypeToRefProdProviderAudit
				(RefLicenseTypeId, RefProdproviderId, ConcurrencyId, RefLicenseTypeToRefProdProviderId, StampAction, StampDateTime, StampUser)
				SELECT
				RefLicenseTypeId, RefProdproviderId, ConcurrencyId, @lastRefLicenseTypeToRefProdProviderId, @StampAction, @StampDateTime, @StampUser
				FROM  policymanagement..TRefLicenseTypeToRefProdProvider
				WHERE RefProdproviderId = @RefProdProviderId
            END
        END TRY

        BEGIN CATCH
            SET @ErrorMessage = ERROR_MESSAGE()
            RAISERROR(@ErrorMessage, 16, 1)
            WHILE(@@TRANCOUNT > 0)ROLLBACK
            RETURN
        END CATCH

        INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF

RETURN;