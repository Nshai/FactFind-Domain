 
-----------------------------------------------------------------------------
-- Table: Administration.TIndigoClientPreference
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '1C16961A-AE76-4639-8B88-47071E1F8300'
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
        SET IDENTITY_INSERT TIndigoClientPreference ON; 
 
        INSERT INTO TIndigoClientPreference([IndigoClientPreferenceId], [IndigoClientId], [IndigoClientGuid], [PreferenceName], [Value], [Disabled], [Guid], [ConcurrencyId])
        SELECT 1927,466, '9D7C163A-1166-45E9-B9E7-712388CE038E', 'SubscribedToPriceFeed', '1',0,'0E3E0036-56C3-414A-8574-DDB774854856',2 
 
        SET IDENTITY_INSERT TIndigoClientPreference OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '1C16961A-AE76-4639-8B88-47071E1F8300', 
         'Initial load (1 total rows, file 1 of 1) for table TIndigoClientPreference',
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
