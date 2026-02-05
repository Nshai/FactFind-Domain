 
-----------------------------------------------------------------------------
-- Table: Administration.TRefEmailStorageConfig
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '01F9BA45-C02B-4576-86DF-88B39C761C95'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefEmailStorageConfig ON; 
 
        INSERT INTO TRefEmailStorageConfig([RefEmailStorageConfigId], [StorageConfigName], [IsTenantOnly], [ConcurrencyId])
        SELECT 1, 'Yes',0,1 UNION ALL 
        SELECT 2, 'No',0,1 UNION ALL 
        SELECT 3, 'User',1,1 
 
        SET IDENTITY_INSERT TRefEmailStorageConfig OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '01F9BA45-C02B-4576-86DF-88B39C761C95', 
         'Initial load (3 total rows, file 1 of 1) for table TRefEmailStorageConfig',
         null, 
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
-- #Rows Exported: 3
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
