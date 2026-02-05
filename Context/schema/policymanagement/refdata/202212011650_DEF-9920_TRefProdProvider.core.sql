USE PolicyManagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
    , @Comments VARCHAR(255)
    , @ErrorMessage VARCHAR(MAX)
    , @StampAction CHAR(1) = 'U'
	, @StampDateTime AS DATETIME = GETUTCDATE()
	, @StampUser AS VARCHAR(255) = '0'

SELECT @ScriptGUID = '9CB456A6-247B-404A-82A1-D40D99F7BAC5'
    , @Comments = 'DEF-9920 Edit existing provider name and archive flag, and archive unnecessary provider.'

IF EXISTS (SELECT 1
FROM TExecutedDataScript
WHERE ScriptGUID = @ScriptGUID)
    RETURN;

/*
    Expected row counts:
    (10 rows affected)
*/

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY

    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
    BEGIN TRANSACTION

        UPDATE CRM..TCorporate
        SET CorporateName = 'Psigma Investment Management', ConcurrencyId+=1
        OUTPUT
             deleted.[IndClientId]
            ,deleted.[CorporateName]
            ,deleted.[ArchiveFG]
            ,deleted.[BusinessType]
            ,deleted.[RefCorporateTypeId]
            ,deleted.[CompanyRegNo]
            ,deleted.[EstIncorpDate]
            ,deleted.[YearEnd]
            ,deleted.[VatRegFg]
            ,deleted.[Extensible]
            ,deleted.[VatRegNo]
            ,deleted.[ConcurrencyId]
            ,deleted.[CorporateId]
            ,@StampAction
            ,@StampDateTime
            ,@StampUser
            ,deleted.[MigrationRef]
            ,deleted.[LEI]
            ,deleted.[LEIExpiryDate]
        INTO CRM..TCorporateAudit ([IndClientId]
            ,[CorporateName]
            ,[ArchiveFG]
            ,[BusinessType]
            ,[RefCorporateTypeId]
            ,[CompanyRegNo]
            ,[EstIncorpDate]
            ,[YearEnd]
            ,[VatRegFg]
            ,[Extensible]
            ,[VatRegNo]
            ,[ConcurrencyId]
            ,[CorporateId]
            ,[StampAction]
            ,[StampDateTime]
            ,[StampUser]
            ,[MigrationRef]
            ,[LEI]
            ,[LEIExpiryDate])
        FROM crm.dbo.TCorporate
        WHERE CorporateId = 4042        

        UPDATE CRM..TCRMContact
        SET ArchiveFg=0, CorporateName='Psigma Investment Management', ConcurrencyId += 1
        OUTPUT
             deleted.[RefCRMContactStatusId]
            ,deleted.[PersonId]
            ,deleted.[CorporateId]
            ,deleted.[TrustId]
            ,deleted.[AdvisorRef]
            ,deleted.[RefSourceOfClientId]
            ,deleted.[SourceValue]
            ,deleted.[Notes]
            ,deleted.[ArchiveFg]
            ,deleted.[LastName]
            ,deleted.[FirstName]
            ,deleted.[CorporateName]
            ,deleted.[DOB]
            ,deleted.[Postcode]
            ,deleted.[OriginalAdviserCRMId]
            ,deleted.[CurrentAdviserCRMId]
            ,deleted.[CurrentAdviserName]
            ,deleted.[CRMContactType]
            ,deleted.[IndClientId]
            ,deleted.[FactFindId]
            ,deleted.[InternalContactFG]
            ,deleted.[RefServiceStatusId]
            ,deleted.[AdviserAssignedByUserId]
            ,deleted.[_ParentId]
            ,deleted.[_ParentTable]
            ,deleted.[_ParentDb]
            ,deleted.[_OwnerId]
            ,deleted.[MigrationRef]
            ,deleted.[CreatedDate]
            ,deleted.[ExternalReference]
            ,deleted.[AdditionalRef]
            ,deleted.[CampaignDataId]
            ,deleted.[FeeModelId]
            ,deleted.[ConcurrencyId]
            ,deleted.[CRMContactId]
            ,@StampAction
            ,@StampDateTime
            ,@StampUser
            ,deleted.[ServiceStatusStartDate]
            ,deleted.[ClientTypeId]
            ,deleted.[IsHeadOfFamilyGroup]
            ,deleted.[FamilyGroupCreationDate]
            ,deleted.[IsDeleted]
        INTO CRM..TCRMContactAudit(
             [RefCRMContactStatusId]
            ,[PersonId]
            ,[CorporateId]
            ,[TrustId]
            ,[AdvisorRef]
            ,[RefSourceOfClientId]
            ,[SourceValue]
            ,[Notes]
            ,[ArchiveFg]
            ,[LastName]
            ,[FirstName]
            ,[CorporateName]
            ,[DOB]
            ,[Postcode]
            ,[OriginalAdviserCRMId]
            ,[CurrentAdviserCRMId]
            ,[CurrentAdviserName]
            ,[CRMContactType]
            ,[IndClientId]
            ,[FactFindId]
            ,[InternalContactFG]
            ,[RefServiceStatusId]
            ,[AdviserAssignedByUserId]
            ,[_ParentId]
            ,[_ParentTable]
            ,[_ParentDb]
            ,[_OwnerId]
            ,[MigrationRef]
            ,[CreatedDate]
            ,[ExternalReference]
            ,[AdditionalRef]
            ,[CampaignDataId]
            ,[FeeModelId]
            ,[ConcurrencyId]
            ,[CRMContactId]
            ,[StampAction]
            ,[StampDateTime]
            ,[StampUser]
            ,[ServiceStatusStartDate]
            ,[ClientTypeId]
            ,[IsHeadOfFamilyGroup]
            ,[FamilyGroupCreationDate]
            ,[IsDeleted])
        WHERE CRMContactId=140676

        UPDATE CRM..TCRMContact
        SET ArchiveFg=1, ConcurrencyId += 1
        OUTPUT
             deleted.[RefCRMContactStatusId]
            ,deleted.[PersonId]
            ,deleted.[CorporateId]
            ,deleted.[TrustId]
            ,deleted.[AdvisorRef]
            ,deleted.[RefSourceOfClientId]
            ,deleted.[SourceValue]
            ,deleted.[Notes]
            ,deleted.[ArchiveFg]
            ,deleted.[LastName]
            ,deleted.[FirstName]
            ,deleted.[CorporateName]
            ,deleted.[DOB]
            ,deleted.[Postcode]
            ,deleted.[OriginalAdviserCRMId]
            ,deleted.[CurrentAdviserCRMId]
            ,deleted.[CurrentAdviserName]
            ,deleted.[CRMContactType]
            ,deleted.[IndClientId]
            ,deleted.[FactFindId]
            ,deleted.[InternalContactFG]
            ,deleted.[RefServiceStatusId]
            ,deleted.[AdviserAssignedByUserId]
            ,deleted.[_ParentId]
            ,deleted.[_ParentTable]
            ,deleted.[_ParentDb]
            ,deleted.[_OwnerId]
            ,deleted.[MigrationRef]
            ,deleted.[CreatedDate]
            ,deleted.[ExternalReference]
            ,deleted.[AdditionalRef]
            ,deleted.[CampaignDataId]
            ,deleted.[FeeModelId]
            ,deleted.[ConcurrencyId]
            ,deleted.[CRMContactId]
            ,@StampAction
            ,@StampDateTime
            ,@StampUser
            ,deleted.[ServiceStatusStartDate]
            ,deleted.[ClientTypeId]
            ,deleted.[IsHeadOfFamilyGroup]
            ,deleted.[FamilyGroupCreationDate]
            ,deleted.[IsDeleted]
        INTO CRM..TCRMContactAudit(
             [RefCRMContactStatusId]
            ,[PersonId]
            ,[CorporateId]
            ,[TrustId]
            ,[AdvisorRef]
            ,[RefSourceOfClientId]
            ,[SourceValue]
            ,[Notes]
            ,[ArchiveFg]
            ,[LastName]
            ,[FirstName]
            ,[CorporateName]
            ,[DOB]
            ,[Postcode]
            ,[OriginalAdviserCRMId]
            ,[CurrentAdviserCRMId]
            ,[CurrentAdviserName]
            ,[CRMContactType]
            ,[IndClientId]
            ,[FactFindId]
            ,[InternalContactFG]
            ,[RefServiceStatusId]
            ,[AdviserAssignedByUserId]
            ,[_ParentId]
            ,[_ParentTable]
            ,[_ParentDb]
            ,[_OwnerId]
            ,[MigrationRef]
            ,[CreatedDate]
            ,[ExternalReference]
            ,[AdditionalRef]
            ,[CampaignDataId]
            ,[FeeModelId]
            ,[ConcurrencyId]
            ,[CRMContactId]
            ,[StampAction]
            ,[StampDateTime]
            ,[StampUser]
            ,[ServiceStatusStartDate]
            ,[ClientTypeId]
            ,[IsHeadOfFamilyGroup]
            ,[FamilyGroupCreationDate]
            ,[IsDeleted])
        WHERE CRMContactId=34672196

        UPDATE PolicyManagement..TRefProdProvider
        SET RetireFg=0
        OUTPUT
             deleted.[CRMContactId]
            ,deleted.[FundProviderId]
            ,deleted.[NewProdProviderId]
            ,deleted.[RetireFg]
            ,deleted.[ConcurrencyId]
            ,deleted.[RefProdProviderId]
            ,@StampAction
            ,@StampDateTime
            ,@StampUser
            ,deleted.[IsTransactionFeedSupported]
            ,deleted.[IsConsumerFriendly]
            ,deleted.[RegionCode]
            ,deleted.[IsBankAccountTransactionFeed]
        INTO policymanagement..TRefProdProviderAudit(
             [CRMContactId]
            ,[FundProviderId]
            ,[NewProdProviderId]
            ,[RetireFg]
            ,[ConcurrencyId]
            ,[RefProdProviderId]
            ,[StampAction]
            ,[StampDateTime]
            ,[StampUser]
            ,[IsTransactionFeedSupported]
            ,[IsConsumerFriendly]
            ,[RegionCode]
            ,[IsBankAccountTransactionFeed])
        WHERE CRMContactId=140676

        UPDATE PolicyManagement..TRefProdProvider
        SET RetireFg=1
        OUTPUT
             deleted.[CRMContactId]
            ,deleted.[FundProviderId]
            ,deleted.[NewProdProviderId]
            ,deleted.[RetireFg]
            ,deleted.[ConcurrencyId]
            ,deleted.[RefProdProviderId]
            ,@StampAction
            ,@StampDateTime
            ,@StampUser
            ,deleted.[IsTransactionFeedSupported]
            ,deleted.[IsConsumerFriendly]
            ,deleted.[RegionCode]
            ,deleted.[IsBankAccountTransactionFeed]
        INTO policymanagement..TRefProdProviderAudit(
             [CRMContactId]
            ,[FundProviderId]
            ,[NewProdProviderId]
            ,[RetireFg]
            ,[ConcurrencyId]
            ,[RefProdProviderId]
            ,[StampAction]
            ,[StampDateTime]
            ,[StampUser]
            ,[IsTransactionFeedSupported]
            ,[IsConsumerFriendly]
            ,[RegionCode]
            ,[IsBankAccountTransactionFeed])
        WHERE CRMContactId=34672196

        INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

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

       /*Insert into logging table - IF ANY	*/

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION
    
       RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;