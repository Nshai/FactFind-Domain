 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefEvalueIncreaseType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'CDD84436-30FD-4E91-8EDD-543E26A5BAE5'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefEvalueIncreaseType ON; 
 
        INSERT INTO TRefEvalueIncreaseType([RefEvalueIncreaseTypeId], [IncreaseType], [ConcurrencyId])
        SELECT 1, 'Fixed % and Esc %',1 UNION ALL 
        SELECT 2, 'RPI',1 UNION ALL 
        SELECT 3, 'Level',1 UNION ALL 
        SELECT 4, 'NAEI',1 UNION ALL 
        SELECT 5, 'LPI',1 
 
        SET IDENTITY_INSERT TRefEvalueIncreaseType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'CDD84436-30FD-4E91-8EDD-543E26A5BAE5', 
         'Initial load (5 total rows, file 1 of 1) for table TRefEvalueIncreaseType',
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
-- #Rows Exported: 5
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
