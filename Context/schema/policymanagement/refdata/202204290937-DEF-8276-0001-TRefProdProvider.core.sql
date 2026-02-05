USE [policymanagement];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
	,@Comments VARCHAR(255)
	,@ErrorMessage VARCHAR(MAX)

SELECT @ScriptGUID = '56DFE5DB-197E-48C0-AF4E-B8F5F01DA47B'
	,@Comments = 'DEF-8276 Create Provider'

IF EXISTS (
		SELECT 1
		FROM TExecutedDataScript
		WHERE ScriptGUID = @ScriptGUID
		)
	RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Add new provider(s)
-- Expected records added: 1 row(s)
-----------------------------------------------------------------------------------------------
SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount INT
	,@StampAction CHAR(1) = 'C'
	,@StampDateTime AS DATETIME = GETUTCDATE()
	,@StampUser AS VARCHAR(255) = '0'

BEGIN TRY
	SELECT @starttrancount = @@TRANCOUNT

	IF @starttrancount = 0
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
		 ('Accord Legal Services Ltd','GB',0,0,0)

	--
	-- Now remove the candidates that already exist in the actual dbs
	--
	DELETE cand
	FROM #TProviderCandidates cand
	JOIN TRefProdProvider p ON p.RegionCode = cand.RegionCode
	JOIN crm.dbo.TCRMContact c ON c.CRMContactId = p.CRMContactId
		AND c.CorporateName = cand.ProviderName

	-- So now we have a list of Candidates that need adding
	-- First add the TCorporate row
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

	-- TCorporateAudit
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

	--
	-- TCRMContact
	--
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

	--
	-- TCRMContactAudit
	--
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

	--
	-- TRefProdProvider
	--
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

	--
	-- TRefProdProviderAudit
	--
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

	-- TRefLicenseTypeToRefProdProvider
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

	INSERT TExecutedDataScript (
		ScriptGUID
		,Comments
		)
	VALUES (
		@ScriptGUID
		,@Comments
		)

	IF @starttrancount = 0
		COMMIT TRANSACTION
END TRY

BEGIN CATCH
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT
	DECLARE @ErrorLine INT
	DECLARE @ErrorNumber INT
	DECLARE @ErrorProc sysname

	SELECT @ErrorMessage = ERROR_MESSAGE()
		,@ErrorSeverity = ERROR_SEVERITY()
		,@ErrorState = ERROR_STATE()
		,@ErrorNumber = ERROR_NUMBER()
		,@ErrorLine = ERROR_LINE()
		,@ErrorProc = ERROR_PROCEDURE()

	IF XACT_STATE() <> 0
		AND @starttrancount = 0
		ROLLBACK TRANSACTION

		RAISERROR ('ErrorNo: %d, Severity: %d, State: %d, Procedure: %s, Line %d, Message %s',1,1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProc, @ErrorLine, @ErrorMessage);
		
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
