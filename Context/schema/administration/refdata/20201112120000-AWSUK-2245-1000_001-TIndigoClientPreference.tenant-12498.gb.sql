 
-----------------------------------------------------------------------------
-- Table: Administration.TIndigoClientPreference
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '1C16961A-AE76-4639-8B88-47071E1F8300'
     AND TenantId = 12498
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TIndigoClientPreference ON; 
 
        INSERT INTO TIndigoClientPreference([IndigoClientPreferenceId], [IndigoClientId], [IndigoClientGuid], [PreferenceName], [Value], [Disabled], [Guid], [ConcurrencyId])
        SELECT 27247,12498, '14015fb2-5edc-497e-acd7-91925877f8dc', 'AddClient_DuplicateChecking', 'EntireCompany',0,'B7F6C923-5025-4324-A20A-5F427CB69060',1 UNION ALL 
        SELECT 27248,12498, '14015fb2-5edc-497e-acd7-91925877f8dc', 'AddClient_DuplicateChecking_SearchType', 'ByWildCardOnInitial',0,'B7B27DF6-1344-4A9D-BEFA-368FA2883339',1 UNION ALL 
        SELECT 27244,12498, '14015fb2-5edc-497e-acd7-91925877f8dc', 'AtrModelProvider', 'A68438C2-AB2C-4E2D-ABA2-502FD4E3876F',0,'18397C39-B644-447F-A92D-3A5A3CA98EE9',1 UNION ALL 
        SELECT 28844,12498, '14015fb2-5edc-497e-acd7-91925877f8dc', 'AtrModelProvider', '9D7C163A-1166-45E9-B9E7-712388CE038E',0,'DC9F16D5-D7BB-4E90-B06F-D7585389714A',1 UNION ALL 
        SELECT 27240,12498, '14015FB2-5EDC-497E-ACD7-91925877F8DC', 'AtrProfileProvider', 'A68438C2-AB2C-4E2D-ABA2-502FD4E3876F',0,'B37B95DD-BAF4-4AF6-AFF7-CFCFD3CDB302',1 UNION ALL 
        SELECT 27241,12498, '14015FB2-5EDC-497E-ACD7-91925877F8DC', 'AtrProfileProvider', '9D7C163A-1166-45E9-B9E7-712388CE038E',0,'8B163F9C-A3F8-4C52-BE5F-0E20B6DC99F8',1 UNION ALL 
        SELECT 27245,12498, '14015fb2-5edc-497e-acd7-91925877f8dc', 'AuthorContentProvider', 'E6E827EA-8A6F-4318-A74F-3E9B1B32C195',0,'B0500288-55EA-4A40-A756-41E2769403A9',1 UNION ALL 
        SELECT 27243,12498, '14015FB2-5EDC-497E-ACD7-91925877F8DC', 'SubscribedToFundAnalysis', '1',0,'CF52C450-38B2-4C10-8188-99183D7E4EB0',1 UNION ALL 
        SELECT 27242,12498, '14015FB2-5EDC-497E-ACD7-91925877F8DC', 'SubscribedToPriceFeed', '1',0,'C00B7CBE-52A5-4105-9509-22948D82550E',1 
 
        SET IDENTITY_INSERT TIndigoClientPreference OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '1C16961A-AE76-4639-8B88-47071E1F8300', 
         'Initial load (9 total rows, file 1 of 1) for table TIndigoClientPreference',
         12498, 
         getdate() )
 
   IF @starttrancount = 0
    COMMIT TRANSACTION
 
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH
 
 SET XACT_ABORT OFF
 SET NOCOUNT OFF
-----------------------------------------------------------------------------
-- #Rows Exported: 9
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
