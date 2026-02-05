 
-----------------------------------------------------------------------------
-- Table: CRM.TRefTaskStatus
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '6C7576AB-B144-4E70-8792-B078048018A5'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefTaskStatus ON; 
 
        INSERT INTO TRefTaskStatus([RefTaskStatusId], [Name], [ConcurrencyId])
        SELECT 5, 'Not Started',1 UNION ALL 
        SELECT 4, 'Waiting for Response',1 UNION ALL 
        SELECT 3, 'Work in Progress',1 UNION ALL 
        SELECT 2, 'Complete',1 UNION ALL 
        SELECT 1, 'Incomplete',1 UNION ALL 
        SELECT 6, 'All open tasks & appointments',1 
 
        SET IDENTITY_INSERT TRefTaskStatus OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '6C7576AB-B144-4E70-8792-B078048018A5', 
         'Initial load (6 total rows, file 1 of 1) for table TRefTaskStatus',
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
-- #Rows Exported: 6
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
