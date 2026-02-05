USE [policymanagement];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT 
    @ScriptGUID = '17266E5A-1AB0-4DA1-8FAB-E5D745F231CF',
    @Comments = 'AWSUK-7325 Districbute Product Providers added to prod uk since refdata changes via script launcher'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Add new US provider Citi

-- Expected records added: 8 rows
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int
       ,@StampAction char(1) = 'C'
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
			DROP TABLE #TAddedProvider

        CREATE TABLE #TProviderCandidates(ProviderName VARCHAR(255), RegionCode VARCHAR(2), IsConsumerFriendly BIT, IsTransactionFeedSupported BIT, IsBankAccountTransactionFeed BIT)
        CREATE TABLE #TAddedCorporate(CorporateId INT, CorporateName VARCHAR(255))
		CREATE TABLE #TAddedCRMContact(CRMContactId INT, CorporateId INT, CorporateName VARCHAR(255))
        CREATE TABLE #TAddedProviders(RefProdProviderId INT)

		INSERT INTO #TProviderCandidates(ProviderName, RegionCode, IsConsumerFriendly, IsTransactionFeedSupported, IsBankAccountTransactionFeed)
		VALUES
			 ('Markel UK', 'GB', 0, 0, 0)
			,('Hanover Pensions', 'GB', 0, 0, 0)
			,('APS Legal & Associates Limited', 'GB', 0, 0, 0)
			,('InvestEngine Limited', 'GB', 0, 0, 0)
			,('Rate Setter ', 'GB', 0, 0, 0)
			,('Lending Crowd', 'GB', 0, 0, 0)
			,('Cerno Capital Partners LLP', 'GB', 0, 0, 0)
			,('Pension Bee', 'GB', 0, 0, 0)
			,('Monument Life', 'GB', 0, 0, 0)
			,('Open Banking - Chelsea Building Society', 'GB', 0, 0, 1)
			,('Open Banking - Cater Allen', 'GB', 0, 0, 1)
			,('Open Banking - Coutts and Company', 'GB', 0, 0, 1)
			,('Open Banking - Revolut', 'GB', 0, 0, 1)
			,('Open Banking - Starling Bank', 'GB', 0, 0, 1)
			,('Open Banking - Tide', 'GB', 0, 0, 1)
			,('Open Banking - Vanquis Bank', 'GB', 0, 0, 1)
			,('Open Banking - Capital One', 'GB', 0, 0, 1)
			,('Open Banking - Cashplus', 'GB', 0, 0, 1)
			,('Open Banking - Cumberland Building Society', 'GB', 0, 0, 1)
			,('Open Banking - Paypal', 'GB', 0, 0, 1)
			,('Open Banking - Sainsburys Bank', 'GB', 0, 0, 1)
			,('Habito', 'GB', 0, 0, 0)
			,('Embark Pensions', 'GB', 0, 0, 0)
			,('Allica Bank', 'GB', 0, 0, 0)
			,('AXA Health', 'GB', 0, 0, 0)
			,('Impact Specialist Finance', 'GB', 0, 0, 0)
			,('Eripsa', 'GB', 0, 0, 0)
			,('TransferWise', 'GB', 0, 0, 0)
			,('Exo Investing Limited', 'GB', 0, 0, 0)
			,('International Private Finance', 'GB', 0, 0, 0)
			,('BUPA Global', 'GB', 0, 0, 0)
			,('Platform Mainstream', 'GB', 0, 0, 0)
			,('Open Money', 'GB', 0, 0, 0)
			,('Novus Bank', 'GB', 0, 0, 0)
			,('Molo Finance', 'GB', 0, 0, 0)
			,('Millennium bcp', 'GB', 0, 0, 0)
			,('British Airways', 'GB', 0, 0, 0)
			,('Gresham House', 'GB', 0, 0, 0)
			,('Wealthsimple', 'GB', 0, 0, 0)
			,('Street UK', 'GB', 0, 0, 0)
			,('Mariana UFP LLP', 'GB', 0, 0, 0)
			,('Voyager Asset Management', 'GB', 0, 0, 0)
			,('Mercia Asset Management', 'GB', 0, 0, 0)
			,('Reinsure Group of America', 'GB', 0, 0, 0)
			,('Cura Insurance ', 'GB', 0, 0, 0)
			,('Protection and Investment Ltd', 'GB', 0, 0, 0)
			,('Radiant', 'GB', 0, 0, 0)
			,('WestBridge', 'GB', 0, 0, 0)
			,('MB Structured Investments', 'GB', 0, 0, 0)
			,('Wood PLC', 'GB', 0, 0, 0)
			,('Whitman Asset Management', 'GB', 0, 0, 0)
			,('Barwood Capital ', 'GB', 0, 0, 0)
			,('Citi', 'US', 1, 0, 0)
			,('Equifinance Limited', 'GB', 0, 0, 0)
			,('Charles Stanley Direct', 'GB', 0, 0, 0)
			,('Causeway Securities Ltd', 'GB', 0, 0, 0)
			,('iPensions Group', 'GB', 0, 0, 0)
			,('Budget Insurance', 'GB', 0, 0, 0)
			,('Hymans Robertson LLP', 'GB', 0, 0, 0)
			,('North East Scotland Pension Fund', 'GB', 0, 0, 0)
			,('Oplo', 'GB', 0, 0, 0)
			,('Causeway Securities', 'GB', 0, 0, 0)
			,('Pension Insurance Corporation', 'GB', 0, 0, 0)
			,('Aegon Retiready', 'GB', 0, 0, 0)
			,('Willis Owen', 'GB', 0, 0, 0)
			,('Think Property Finance Ltd', 'GB', 0, 0, 0)
			,('Selina Finance Limited', 'GB', 0, 0, 0)
			,('Freetrade', 'GB', 0, 0, 0)
			,('Retirment Capital', 'GB', 0, 0, 0)
			,('Seccl', 'GB', 0, 0, 0)
			,('Avamore Capital', 'GB', 0, 0, 0)
			,('ivari', 'GB', 0, 0, 0)
			,('Aegon Asset Management', 'GB', 0, 0, 0)
			,('CIty National Bank', 'GB', 0, 0, 0)
			,('Monument International', 'GB', 0, 0, 0)
			,('PMS Mortgage Club', 'GB', 0, 0, 0)
			,('Abrdn', 'GB', 0, 0, 0)
			,('Glenhawk Property Finance Limited ', 'GB', 0, 0, 0)
			,('NSS Trustees Limited ', 'GB', 0, 0, 0)
			,('Magenta (Inet3 ltd)', 'GB', 0, 0, 0)
			,('Trading 212', 'GB', 0, 0, 0)
			,('Sovereign Trust (Gibraltar) Limited', 'GB', 0, 0, 0)
			,('OPLO HL Ltd', 'GB', 0, 0, 0)
			,('RGA International Reinsurance Company DAC', 'GB', 0, 0, 0)
			,('Pensionhelp Limited', 'GB', 0, 0, 0)
			,('Tyndall', 'GB', 0, 0, 0)
			,('Odd Asset Management ', 'GB', 0, 0, 0)
			,('Voyager Insurance', 'GB', 0, 0, 0)
			,('Waystone Management UK', 'GB', 0, 0, 0)
			,('Tesla Financial Services Limited', 'GB', 0, 0, 0)
			,('Old Mill', 'GB', 0, 0, 0)
			,('Ardan International', 'GB', 0, 0, 0)
			,('AAMI', 'AU', 0, 0, 0)
			,('Allianz', 'AU', 0, 0, 0)
			,('Asteron', 'AU', 0, 0, 0)
			,('Aware Super', 'AU', 0, 0, 0)
			,('Crescent Wealth', 'AU', 0, 0, 0)
			,('Industry Super', 'AU', 0, 0, 0)
			,('Government Scheme', 'AU', 0, 0, 0)
			,('Unknown Provider', 'AU', 1, 0, 0)

        --
		-- Now remove the candidates that already exist in the actual dbs
		--
		DELETE cand
		FROM
			#TProviderCandidates cand
			JOIN TRefProdProvider p 
				ON p.RegionCode = cand.RegionCode
			JOIN crm.dbo.TCRMContact c 
				ON c.CRMContactId = p.CRMContactId  
				AND c.CorporateName = cand.ProviderName
		
		-- So now we have a list of Candidates that need adding

		-- First add the TCorporate row
        INSERT INTO crm.dbo.TCorporate 
		(
			IndClientId, CorporateName, RefCorporateTypeId
		) 
        OUTPUT inserted.CorporateId, inserted.CorporateName
        INTO #TAddedCorporate
		SELECT 0, ProviderName, 1 
		FROM
			#TProviderCandidates cand

        -- TCorporateAudit
        INSERT INTO crm.dbo.TCorporateAudit  
              ([IndClientId],[CorporateName],[ArchiveFG],[BusinessType],[RefCorporateTypeId],[CompanyRegNo],[EstIncorpDate],[YearEnd],[VatRegFg]
              ,[Extensible],[VatRegNo],[ConcurrencyId],[CorporateId],[StampAction],[StampDateTime],[StampUser],[MigrationRef],[LEI],[LEIExpiryDate])
        SELECT [IndClientId],[CorporateName],[ArchiveFG],[BusinessType],[RefCorporateTypeId],[CompanyRegNo],[EstIncorpDate],[YearEnd],[VatRegFg]
              ,[Extensible],[VatRegNo],[ConcurrencyId],[CorporateId],@StampAction, @StampDateTime, @StampUser,[MigrationRef],[LEI],[LEIExpiryDate]
        FROM  crm.dbo.TCorporate
        WHERE CorporateId IN (SELECT CorporateId FROM #TAddedCorporate) 
		
		--
        -- TCRMContact
        --
		INSERT INTO crm.dbo.TCRMContact (CorporateId, CorporateName, IndClientId)
        OUTPUT inserted.CRMContactId, inserted.CorporateId, inserted.CorporateName
        INTO #TAddedCRMContact
        SELECT CorporateId, CorporateName, 0 
        FROM #TAddedCorporate

        --
		-- TCRMContactAudit
        --
		INSERT INTO crm.dbo.TCRMContactAudit
        (
				[RefCRMContactStatusId],[PersonId],[CorporateId],[TrustId],[AdvisorRef],[RefSourceOfClientId],[SourceValue],[Notes],[ArchiveFg],[LastName]
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
        FROM crm.dbo.TCRMContact
        WHERE CRMContactId IN (SELECT CRMContactId FROM #TAddedCRMContact)

        --
		-- TRefProdProvider
        --
		INSERT INTO TRefProdProvider 
		(
			  CRMContactId
			 ,RegionCode
			 ,IsConsumerFriendly
			 ,IsTransactionFeedSupported
			 ,IsBankAccountTransactionFeed
		)
        OUTPUT inserted.RefProdProviderId
        INTO #TAddedProviders
        SELECT 
			 crm.CRMContactId
			,cand.RegionCode
			,cand.IsConsumerFriendly
			,cand.IsTransactionFeedSupported
			,cand.IsBankAccountTransactionFeed
        FROM 
			#TAddedCRMContact crm
			JOIN #TProviderCandidates cand
				ON cand.ProviderName = crm.CorporateName

        --
		-- TRefProdProviderAudit
        --
		INSERT INTO policymanagement..TRefProdProviderAudit
        (
			[CRMContactId],[FundProviderId],[NewProdProviderId],[RetireFg],[ConcurrencyId],[RefProdProviderId],[StampAction],[StampDateTime],[StampUser],[IsTransactionFeedSupported]
            ,[IsConsumerFriendly],[RegionCode],[IsBankAccountTransactionFeed]
		)
        SELECT 
			[CRMContactId],[FundProviderId],[NewProdProviderId],[RetireFg],[ConcurrencyId], p.[RefProdProviderId] ,@StampAction,@StampDateTime,@StampUser,[IsTransactionFeedSupported]
            ,[IsConsumerFriendly],[RegionCode],[IsBankAccountTransactionFeed]
        FROM 
			policymanagement..TRefProdProvider p
			JOIN #TAddedProviders ap ON ap.RefProdProviderId = p.RefProdProviderId

        -- TRefLicenseTypeToRefProdProvider
        INSERT INTO policymanagement..TRefLicenseTypeToRefProdProvider (RefProdproviderId, RefLicenseTypeId)
        OUTPUT inserted.RefLicenseTypeToRefProdProviderId,
               inserted.RefProdproviderId,
               inserted.RefLicenseTypeId, 
               inserted.ConcurrencyId,
               @StampAction,
               @StampDateTime,
               @StampUser
        INTO policymanagement..TRefLicenseTypeToRefProdProviderAudit
        SELECT RefProdProviderId, 1
        FROM #TAddedProviders           

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

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION

       RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;