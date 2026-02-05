 
-----------------------------------------------------------------------------
-- Table: Administration.TRefEmailDuplicateConfig
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'DC32A6F7-5581-41F7-9786-7CD0902B1054'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefEmailDuplicateConfig ON; 
 
        INSERT INTO TRefEmailDuplicateConfig([RefEmailDuplicateConfigId], [DuplicateConfigName], [ConcurrencyId])
        SELECT 1, 'Associate to record with greatest number of activities',1 UNION ALL 
        SELECT 2, 'Associate to record with earliest creation date',1 UNION ALL 
        SELECT 3, 'Associate to all records',1 
 
        SET IDENTITY_INSERT TRefEmailDuplicateConfig OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'DC32A6F7-5581-41F7-9786-7CD0902B1054', 
         'Initial load (3 total rows, file 1 of 1) for table TRefEmailDuplicateConfig',
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
