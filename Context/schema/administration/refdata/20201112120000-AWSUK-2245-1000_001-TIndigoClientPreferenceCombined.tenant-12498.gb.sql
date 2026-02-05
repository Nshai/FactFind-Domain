 
-----------------------------------------------------------------------------
-- Table: Administration.TIndigoClientPreferenceCombined
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '14BEE255-531B-4167-B79A-4D1ECD211D88'
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
 
        INSERT INTO TIndigoClientPreferenceCombined([Guid], [IndigoClientPreferenceId], [IndigoClientId], [IndigoClientGuid], [PreferenceName], [Value], [Disabled], [ConcurrencyId], [msrepl_tran_version])
        SELECT 'B37B95DD-BAF4-4AF6-AFF7-CFCFD3CDB302',27240,12498, '14015FB2-5EDC-497E-ACD7-91925877F8DC', 'AtrProfileProvider', 'A68438C2-AB2C-4E2D-ABA2-502FD4E3876F',0,1,'57C1D46D-2DEF-4E26-BC61-44BB20DACF77' UNION ALL 
        SELECT '8B163F9C-A3F8-4C52-BE5F-0E20B6DC99F8',27241,12498, '14015FB2-5EDC-497E-ACD7-91925877F8DC', 'AtrProfileProvider', '9D7C163A-1166-45E9-B9E7-712388CE038E',0,1,'3270354C-4E39-40A3-865A-B1A528E48802' UNION ALL 
        SELECT 'C00B7CBE-52A5-4105-9509-22948D82550E',27242,12498, '14015FB2-5EDC-497E-ACD7-91925877F8DC', 'SubscribedToPriceFeed', '1',0,1,'7514200A-58BD-401F-826D-D813205602DD' UNION ALL 
        SELECT 'CF52C450-38B2-4C10-8188-99183D7E4EB0',27243,12498, '14015FB2-5EDC-497E-ACD7-91925877F8DC', 'SubscribedToFundAnalysis', '1',0,1,'B208D634-6CE4-48A4-A735-AEAF554F7165' 
 
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '14BEE255-531B-4167-B79A-4D1ECD211D88', 
         'Initial load (4 total rows, file 1 of 1) for table TIndigoClientPreferenceCombined',
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
-- #Rows Exported: 4
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
