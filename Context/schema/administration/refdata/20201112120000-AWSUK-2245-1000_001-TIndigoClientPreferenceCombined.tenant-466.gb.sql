 
-----------------------------------------------------------------------------
-- Table: Administration.TIndigoClientPreferenceCombined
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '14BEE255-531B-4167-B79A-4D1ECD211D88'
     AND TenantId = 466
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
        SELECT '0E3E0036-56C3-414A-8574-DDB774854856',1927,466, '9D7C163A-1166-45E9-B9E7-712388CE038E', 'SubscribedToPriceFeed', '0',0,1,'2EFF07A8-F87E-47AA-BF87-DF707D1A0792' 
 
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '14BEE255-531B-4167-B79A-4D1ECD211D88', 
         'Initial load (1 total rows, file 1 of 1) for table TIndigoClientPreferenceCombined',
         466, 
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
-- #Rows Exported: 1
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
