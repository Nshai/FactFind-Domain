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

SELECT @ScriptGUID = 'F19D12C2-A9D1-4F9D-84D9-89C744B9D6B1'
	,@Comments = 'CRMPM-8176 Create AU Linked Account Providers'

IF EXISTS (
		SELECT 1
		FROM TExecutedDataScript
		WHERE ScriptGUID = @ScriptGUID
		)
	RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Add new AU Linked Account providers
-- Expected records added: 82 rows
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
		(5201,'Linked Account - AMG','AU',0,0,1),
		(5202,'Linked Account - AMP Australia','AU',0,0,1),
		(5203,'Linked Account - ANZ','AU',0,0,1),
		(5204,'Linked Account - Asgard','AU',0,0,1),
		(5205,'Linked Account - Australia Post','AU',0,0,1),
		(5206,'Linked Account - Australian Catholic Super','AU',0,0,1),
		(5207,'Linked Account - Australian Military','AU',0,0,1),
		(5208,'Linked Account - Australian Unity','AU',0,0,1),
		(5209,'Linked Account - Aware Super','AU',0,0,1),
		(5210,'Linked Account - Bank First','AU',0,0,1),
		(5211,'Linked Account - Bank of Melbourne','AU',0,0,1),
		(5212,'Linked Account - Bank of Queensland','AU',0,0,1),
		(5213,'Linked Account - Bank of Sydney','AU',0,0,1),
		(5214,'Linked Account - BankVic','AU',0,0,1),
		(5215,'Linked Account - BankWest','AU',0,0,1),
		(5216,'Linked Account - Bendigo Bank','AU',0,0,1),
		(5217,'Linked Account - BOQ Specialist','AU',0,0,1),
		(5218,'Linked Account - Brighter Super','AU',0,0,1),
		(5219,'Linked Account - BT','AU',0,0,1),
		(5220,'Linked Account - BUSSQ Super','AU',0,0,1),
		(5221,'Linked Account - nabtrade Cash Mgmt.','AU',0,0,1),
		(5222,'Linked Account - Catholic Super','AU',0,0,1),
		(5223,'Linked Account - Child Care Super','AU',0,0,1),
		(5224,'Linked Account - ClearView','AU',0,0,1),
		(5225,'Linked Account - CommBiz','AU',0,0,1),
		(5226,'Linked Account - CBA','AU',0,0,1),
		(5227,'Linked Account - Commonwealth Bank - Employee Equity Plan','AU',0,0,1),
		(5228,'Linked Account - Commonwealth Bank Staff Superfund','AU',0,0,1),
		(5229,'Linked Account - CommSec','AU',0,0,1),
		(5230,'Linked Account - CommSec (Netxinvestor)','AU',0,0,1),
		(5231,'Linked Account - CSS Member - Commonwealth Superannuation Corporation','AU',0,0,1),
		(5232,'Linked Account - CSS Pensioner - Commonwealth Superannuation Corporation','AU',0,0,1),
		(5233,'Linked Account - DFRDB - Commonwealth Superannuation Corporation','AU',0,0,1),
		(5234,'Linked Account - Energy Super','AU',0,0,1),
		(5235,'Linked Account - Gen Life','AU',0,0,1),
		(5236,'Linked Account - Grow Wrap','AU',0,0,1),
		(5237,'Linked Account - Guild Super','AU',0,0,1),
		(5238,'Linked Account - Health Professionals Bank','AU',0,0,1),
		(5239,'Linked Account - Heritage Bank','AU',0,0,1),
		(5240,'Linked Account - ING','AU',0,0,1),
		(5241,'Linked Account - Intrust','AU',0,0,1),
		(5242,'Linked Account - Investment Exchange','AU',0,0,1),
		(5243,'Linked Account - Goldman Sachs & JBWere','AU',0,0,1),
		(5244,'Linked Account - Legal Super','AU',0,0,1),
		(5245,'Linked Account - LUCRF Super','AU',0,0,1),
		(5246,'Linked Account - Macquarie','AU',0,0,1),
		(5247,'Linked Account - Maritime','AU',0,0,1),
		(5248,'Linked Account - Mercer','AU',0,0,1),
		(5249,'Linked Account - Mercy','AU',0,0,1),
		(5250,'Linked Account - MilitarySuper','AU',0,0,1),
		(5251,'Linked Account - MilitarySuper - Commonwealth Superannuation Corporation','AU',0,0,1),
		(5252,'Linked Account - Mine Super','AU',0,0,1),
		(5253,'Linked Account - MyLife','AU',0,0,1),
		(5254,'Linked Account - NAB Connect','AU',0,0,1),
		(5255,'Linked Account - NAB Equity Builder','AU',0,0,1),
		(5256,'Linked Account - NAB Equity Lending','AU',0,0,1),
		(5257,'Linked Account - NAB','AU',0,0,1),
		(5258,'Linked Account - nabtrade','AU',0,0,1),
		(5259,'Linked Account - NGS Super','AU',0,0,1),
		(5260,'Linked Account - Qantas','AU',0,0,1),
		(5261,'Linked Account - Qsuper','AU',0,0,1),
		(5262,'Linked Account - RACQ Bank','AU',0,0,1),
		(5263,'Linked Account - Russell','AU',0,0,1),
		(5264,'Linked Account - Statewide Super','AU',0,0,1),
		(5265,'Linked Account - Suncorp','AU',0,0,1),
		(5266,'Linked Account - Suncorp (Share Trade)','AU',0,0,1),
		(5267,'Linked Account - Suncorp Super','AU',0,0,1),
		(5268,'Linked Account - Super SA','AU',0,0,1),
		(5269,'Linked Account - Teachers Mutual Bank','AU',0,0,1),
		(5270,'Linked Account - Telstra Super','AU',0,0,1),
		(5271,'Linked Account - UniSuper','AU',0,0,1),
		(5272,'Linked Account - VicSuper','AU',0,0,1),
		(5273,'Linked Account - Vision Super','AU',0,0,1),
		(5274,'Linked Account - WA Super','AU',0,0,1),
		(5275,'Linked Account - Westpac','AU',0,0,1),
		(5276,'Linked Account - Westpac Business','AU',0,0,1),
		(5277,'Linked Account - Westpac Corporate','AU',0,0,1),
		(5278,'Linked Account - Westpac Online Investing','AU',0,0,1),
		(5279,'Linked Account - Woolworths','AU',0,0,1),
		(5280,'Linked Account - Woolworths Team Bank','AU',0,0,1),
		(5281,'Linked Account - Yellow Brick Road','AU',0,0,1),
		(5282,'Linked Account - Biza','AU',0,0,1)

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