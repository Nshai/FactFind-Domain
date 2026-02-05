USE [policymanagement];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)


SELECT 
    @ScriptGUID = '334BE945-EF78-4B9E-BF07-8F56576E4EEB',
    @Comments = 'AIOCA-296 Reference Data for US - Add provider Pershing'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Add additional US provider

-- Expected records added: 7 (with audit tables)
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int
       ,@StampAction char(1) = 'C'
       ,@StampDateTime AS DATETIME = GETUTCDATE()
       ,@StampUser AS VARCHAR(255) = '0'
       ,@RegionCode varchar(2) = 'US'	   

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

        IF OBJECT_ID('tempdb..#TCRMContact') IS NOT NULL
        DROP TABLE #TCRMContact
        CREATE TABLE #TCRMContact(IndClientId INT, CorporateId INT, CorporateName varchar(250))

        -- TCorporate
        INSERT INTO crm..TCorporate (IndClientId, CorporateName, RefCorporateTypeId) 
        OUTPUT inserted.IndClientId, inserted.CorporateId, inserted.CorporateName
        INTO #TCRMContact
		VALUES
		(0, 'Pershing', 1)

        -- TCorporateAudit
        INSERT INTO crm..TCorporateAudit  
              ([IndClientId],[CorporateName],[ArchiveFG],[BusinessType],[RefCorporateTypeId],[CompanyRegNo],[EstIncorpDate],[YearEnd],[VatRegFg]
              ,[Extensible],[VatRegNo],[ConcurrencyId],[CorporateId],[StampAction],[StampDateTime],[StampUser],[MigrationRef],[LEI],[LEIExpiryDate])
        SELECT [IndClientId],[CorporateName],[ArchiveFG],[BusinessType],[RefCorporateTypeId],[CompanyRegNo],[EstIncorpDate],[YearEnd],[VatRegFg]
              ,[Extensible],[VatRegNo],[ConcurrencyId],[CorporateId],@StampAction, @StampDateTime, @StampUser,[MigrationRef],[LEI],[LEIExpiryDate]
        FROM  crm..TCorporate
        WHERE CorporateId IN (SELECT CorporateId FROM #TCRMContact) 

        IF OBJECT_ID('tempdb..#TRefProdProviders') IS NOT NULL
        DROP TABLE #TRefProdProviders
        CREATE TABLE #TRefProdProviders(CrmContactId INT)

        -- TCRMContact
        INSERT INTO crm..TCRMContact (CorporateId, CorporateName, IndClientId)
        OUTPUT inserted.CRMContactId
        INTO #TRefProdProviders
        SELECT CorporateId, CorporateName, 0 
        FROM #TCRMContact

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
        WHERE CRMContactId IN (SELECT CRMContactId FROM #TRefProdProviders)

        IF OBJECT_ID('tempdb..#TRefLicenseType_ToProviders') IS NOT NULL
        DROP TABLE #TRefLicenseType_ToProviders
        CREATE TABLE #TRefLicenseType_ToProviders(RefProviderId INT)

        -- TRefProdProvider
        INSERT INTO TRefProdProvider (CRMContactId, RegionCode, IsConsumerFriendly)
        OUTPUT inserted.RefProdProviderId
        INTO #TRefLicenseType_ToProviders
        SELECT CRMContactId, @RegionCode, 1
        FROM #TRefProdProviders

        -- TRefProdProviderAudit
        INSERT INTO TRefProdProviderAudit
        ([CRMContactId],[FundProviderId],[NewProdProviderId],[RetireFg],[ConcurrencyId],[RefProdProviderId],[StampAction],[StampDateTime],[StampUser],[IsTransactionFeedSupported]
              ,[IsConsumerFriendly],[RegionCode],[IsBankAccountTransactionFeed])
        SELECT 
        [CRMContactId],[FundProviderId],[NewProdProviderId],[RetireFg],[ConcurrencyId],[RefProdProviderId] ,@StampAction,@StampDateTime,@StampUser,[IsTransactionFeedSupported]
              ,[IsConsumerFriendly],[RegionCode],[IsBankAccountTransactionFeed]
        FROM TRefProdProvider
        WHERE RefProdProviderId IN (SELECT RefProviderId FROM #TRefLicenseType_ToProviders)

        -- TRefLicenseTypeToRefProdProvider
        INSERT INTO TRefLicenseTypeToRefProdProvider (RefProdproviderId, RefLicenseTypeId)
        OUTPUT inserted.RefLicenseTypeToRefProdProviderId,
               inserted.RefProdproviderId,
               inserted.RefLicenseTypeId, 
               inserted.ConcurrencyId,
               @StampAction,
               @StampDateTime,
               @StampUser
        INTO TRefLicenseTypeToRefProdProviderAudit
        SELECT RefProviderId, 1
        FROM #TRefLicenseType_ToProviders           

        INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

        IF OBJECT_ID('tempdb..#TCRMContact') IS NOT NULL
        DROP TABLE #TCRMContact

        IF OBJECT_ID('tempdb..#TRefProdProviders') IS NOT NULL
        DROP TABLE #TRefProdProviders

        IF OBJECT_ID('tempdb..#TRefLicenseType_ToProviders') IS NOT NULL
        DROP TABLE #TRefLicenseType_ToProviders

    IF @starttrancount = 0 
        COMMIT TRANSACTION

END TRY
BEGIN CATCH

       DECLARE @ErrorSeverity INT
       DECLARE @ErrorState INT
       DECLARE @ErrorLine INT
       DECLARE @ErrorNumber INT

       SELECT @ErrorMessage = ERROR_MESSAGE(),
       @ErrorSeverity = ERROR_SEVERITY(),
       @ErrorState = ERROR_STATE(),
       @ErrorNumber = ERROR_NUMBER(),
       @ErrorLine = ERROR_LINE()

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION

       RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN; 