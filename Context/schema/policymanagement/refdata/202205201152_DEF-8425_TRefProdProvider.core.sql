USE PolicyManagement;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @StampAction CHAR(1) = 'C'
      , @StampDateTime AS DATETIME = GETUTCDATE()
      , @StampUser AS VARCHAR(255) = '0'

/*
Summary
Add new provider

DatabaseName        TableName      Expected Rows
CRM                 TCorporate      1
CRM                 TCRMContact     1
PolicyManagement    TRefProdProvider    1
PolicyManagement    TRefLicenseTypeToRefProdProvider    1
*/


SELECT 
	@ScriptGUID = 'C0F13081-6D73-4399-A286-D4B82CEFB269', 
	@Comments = 'DEF-8425 Create Provider'


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRY

    BEGIN TRANSACTION

    IF OBJECT_ID('tempdb..#TProviderCandidates') IS NOT NULL
		DROP TABLE #TProviderCandidates

	IF OBJECT_ID('tempdb..#TAddedCorporate') IS NOT NULL
		DROP TABLE #TAddedCorporate

	IF OBJECT_ID('tempdb..#TAddedCRMContact') IS NOT NULL
		DROP TABLE #TAddedCRMContact

	IF OBJECT_ID('tempdb..#TAddedProviders') IS NOT NULL
		DROP TABLE #TAddedProviders

    CREATE TABLE #TProviderCandidates (
		ProviderName VARCHAR(255)
		,RegionCode VARCHAR(2)
		,IsConsumerFriendly BIT
		,IsTransactionFeedSupported BIT
		,IsBankAccountTransactionFeed BIT
		)

	CREATE TABLE #TAddedCorporate (
		CorporateId INT
		,CorporateName VARCHAR(255)
		)

	CREATE TABLE #TAddedCRMContact (
		CRMContactId INT
		,CorporateId INT
		,CorporateName VARCHAR(255)
		)

	CREATE TABLE #TAddedProviders (RefProdProviderId INT)

	INSERT INTO #TProviderCandidates (
		ProviderName
		,RegionCode
		,IsConsumerFriendly
		,IsTransactionFeedSupported
		,IsBankAccountTransactionFeed
		)
	VALUES 
		 ('Off-platform','AU',0,0,0)

	DELETE cand
	FROM #TProviderCandidates cand
	JOIN TRefProdProvider p ON p.RegionCode = cand.RegionCode
	JOIN crm.dbo.TCRMContact c ON c.CRMContactId = p.CRMContactId
		AND c.CorporateName = cand.ProviderName

	INSERT INTO crm.dbo.TCorporate (
		IndClientId
		,CorporateName
		,RefCorporateTypeId
		)
	OUTPUT inserted.CorporateId
		,inserted.CorporateName
	INTO #TAddedCorporate
	SELECT 0
		,ProviderName
		,1
	FROM #TProviderCandidates cand

	INSERT INTO crm.dbo.TCorporateAudit (
		[IndClientId]
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
		,[LEIExpiryDate]
		)
	SELECT [IndClientId]
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
		,@StampAction
		,@StampDateTime
		,@StampUser
		,[MigrationRef]
		,[LEI]
		,[LEIExpiryDate]
	FROM crm.dbo.TCorporate
	WHERE CorporateId IN ( SELECT CorporateId	FROM #TAddedCorporate	)

	INSERT INTO crm.dbo.TCRMContact (
		CorporateId
		,CorporateName
		,IndClientId
		)
	OUTPUT inserted.CRMContactId
		,inserted.CorporateId
		,inserted.CorporateName
	INTO #TAddedCRMContact
	SELECT CorporateId
		,CorporateName
		,0
	FROM #TAddedCorporate

	INSERT INTO crm.dbo.TCRMContactAudit (
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
		,[IsDeleted]
		)
	SELECT [RefCRMContactStatusId]
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
		,@StampAction
		,@StampDateTime
		,@StampUser
		,[ServiceStatusStartDate]
		,[ClientTypeId]
		,[IsHeadOfFamilyGroup]
		,[FamilyGroupCreationDate]
		,[IsDeleted]
	FROM crm.dbo.TCRMContact
	WHERE CRMContactId IN (	SELECT CRMContactId	FROM #TAddedCRMContact	)

	INSERT INTO TRefProdProvider (
		CRMContactId
		,RegionCode
		,IsConsumerFriendly
		,IsTransactionFeedSupported
		,IsBankAccountTransactionFeed
		)
	OUTPUT inserted.RefProdProviderId
	INTO #TAddedProviders
	SELECT crm.CRMContactId
		,cand.RegionCode
		,cand.IsConsumerFriendly
		,cand.IsTransactionFeedSupported
		,cand.IsBankAccountTransactionFeed
	FROM #TAddedCRMContact crm
	JOIN #TProviderCandidates cand ON cand.ProviderName = crm.CorporateName

	INSERT INTO policymanagement..TRefProdProviderAudit (
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
		,[IsBankAccountTransactionFeed]
		)
	SELECT [CRMContactId]
		,[FundProviderId]
		,[NewProdProviderId]
		,[RetireFg]
		,[ConcurrencyId]
		,p.[RefProdProviderId]
		,@StampAction
		,@StampDateTime
		,@StampUser
		,[IsTransactionFeedSupported]
		,[IsConsumerFriendly]
		,[RegionCode]
		,[IsBankAccountTransactionFeed]
	FROM policymanagement..TRefProdProvider p
	JOIN #TAddedProviders ap ON ap.RefProdProviderId = p.RefProdProviderId

	INSERT INTO policymanagement..TRefLicenseTypeToRefProdProvider (
		RefProdproviderId
		,RefLicenseTypeId
		)
	OUTPUT inserted.RefLicenseTypeToRefProdProviderId
		,inserted.RefProdproviderId
		,inserted.RefLicenseTypeId
		,inserted.ConcurrencyId
		,@StampAction
		,@StampDateTime
		,@StampUser
	INTO policymanagement..TRefLicenseTypeToRefProdProviderAudit
	SELECT RefProdProviderId,1
	FROM #TAddedProviders
			
    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    COMMIT TRANSACTION

END TRY
BEGIN CATCH
    
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH

    IF OBJECT_ID('tempdb..#TProviderCandidates') IS NOT NULL
		DROP TABLE #TProviderCandidates

	IF OBJECT_ID('tempdb..#TAddedCorporate') IS NOT NULL
		DROP TABLE #TAddedCorporate

	IF OBJECT_ID('tempdb..#TAddedCRMContact') IS NOT NULL
		DROP TABLE #TAddedCRMContact

	IF OBJECT_ID('tempdb..#TAddedProviders') IS NOT NULL
		DROP TABLE #TAddedProviders

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;
 