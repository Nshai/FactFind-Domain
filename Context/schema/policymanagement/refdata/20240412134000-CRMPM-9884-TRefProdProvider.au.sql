USE [policymanagement];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
	,@Comments VARCHAR(255)
	,@ErrorMessage VARCHAR(MAX)
	,@RefProdProviderIdAlreadyExists BIT = 0
	,@CrmContactAlreadyExists BIT = 0
	,@starttrancount INT
	,@StampAction CHAR(1) = 'C'
	,@StampDateTime AS DATETIME = GETUTCDATE()
	,@StampUser AS VARCHAR(255) = '0'

SELECT @ScriptGUID = '6C45A649-D843-4587-82BD-2484CA9BF0CD'
	,@Comments = 'CRMPM-9884 Create AU Linked Account Provider'

IF EXISTS (
		SELECT 1
		FROM TExecutedDataScript
		WHERE ScriptGUID = @ScriptGUID
		)
	RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Add new AU Linked Account provider
-- Expected records added: 1 row
-----------------------------------------------------------------------------------------------
SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

	IF OBJECT_ID('tempdb..#TProviderCandidates') IS NOT NULL
		DROP TABLE #TProviderCandidates

	IF OBJECT_ID('tempdb..#TAddedCorporate') IS NOT NULL
		DROP TABLE #TAddedCorporate

	IF OBJECT_ID('tempdb..#TAddedCRMContact') IS NOT NULL
		DROP TABLE #TAddedCRMContact

	IF OBJECT_ID('tempdb..#TAddedProviders') IS NOT NULL
		DROP TABLE #TAddedProviders

	CREATE TABLE #TProviderCandidates (
		RefProdProviderId INT
		,ProviderName VARCHAR(255)
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
		RefProdProviderId
		,ProviderName
		,RegionCode
		,IsConsumerFriendly
		,IsTransactionFeedSupported
		,IsBankAccountTransactionFeed
		)
	VALUES
		(5350,'Linked Account - CDR Sandbox Testing','AU',0,0,1)

	--
	-- Although one of the CRMContacts already exists
	--
	SELECT @CrmContactAlreadyExists = 1
	FROM #TProviderCandidates cand
	JOIN TRefProdProvider p ON p.RegionCode = cand.RegionCode
	JOIN crm.dbo.TCRMContact c ON c.CRMContactId = p.CRMContactId
		AND c.CorporateName = cand.ProviderName

	--
	-- Although one of the IDs already exists
	--
	SELECT @RefProdProviderIdAlreadyExists = 1
	FROM TRefProdProvider prod
	INNER JOIN #TProviderCandidates cand ON cand.RefProdProviderId = prod.RefProdProviderId

	IF (@CrmContactAlreadyExists = 0 AND @RefProdProviderIdAlreadyExists = 0)
	BEGIN
		SELECT @starttrancount = @@TRANCOUNT

		IF (@starttrancount = 0)
			BEGIN TRANSACTION

			--
			-- TCorporate
			--
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

			--
			-- TCorporateAudit
			--
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
			SET IDENTITY_INSERT TRefProdProvider ON;

			INSERT INTO TRefProdProvider (
				RefProdProviderId
				,CRMContactId
				,RegionCode
				,IsConsumerFriendly
				,IsTransactionFeedSupported
				,IsBankAccountTransactionFeed
				)
			OUTPUT inserted.RefProdProviderId
			INTO #TAddedProviders
			SELECT
				cand.RefProdProviderId
				,crm.CRMContactId
				,cand.RegionCode
				,cand.IsConsumerFriendly
				,cand.IsTransactionFeedSupported
				,cand.IsBankAccountTransactionFeed
			FROM #TAddedCRMContact crm
			JOIN #TProviderCandidates cand ON cand.ProviderName = crm.CorporateName

			SET IDENTITY_INSERT TRefProdProvider OFF

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

			--
			-- TRefLicenseTypeToRefProdProvider and TRefLicenseTypeToRefProdProviderAudit
			--
			INSERT INTO TRefLicenseTypeToRefProdProvider (
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
			INTO TRefLicenseTypeToRefProdProviderAudit
			SELECT RefProdProviderId, 1
			FROM #TAddedProviders

		IF @starttrancount = 0
			COMMIT TRANSACTION
	END

	INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

END TRY

BEGIN CATCH
	SET IDENTITY_INSERT TRefProdProvider OFF

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