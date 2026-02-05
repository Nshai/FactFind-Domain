 
-----------------------------------------------------------------------------
-- Table: CRM.TRefTaskView
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '46F0AEE9-3519-4D1F-87B4-B23C864D9E02'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefTaskView ON; 
 
        INSERT INTO TRefTaskView([RefTaskViewId], [ViewName], [ArchiveFg], [Extensible], [ConcurrencyId])
        SELECT 9, 'Completed',0,NULL,1 UNION ALL 
        SELECT 8, 'All Open',0,NULL,1 UNION ALL 
        SELECT 7, 'This Month',0,NULL,1 UNION ALL 
        SELECT 6, 'Next 7 Days + Overdue',0,NULL,1 UNION ALL 
        SELECT 5, 'Next 7 Days',0,NULL,1 UNION ALL 
        SELECT 4, 'Tomorrow',0,NULL,1 UNION ALL 
        SELECT 3, 'Today + Overdue',0,NULL,1 UNION ALL 
        SELECT 2, 'Today',0,NULL,1 UNION ALL 
        SELECT 1, 'Overdue',0,NULL,1 
 
        SET IDENTITY_INSERT TRefTaskView OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '46F0AEE9-3519-4D1F-87B4-B23C864D9E02', 
         'Initial load (9 total rows, file 1 of 1) for table TRefTaskView',
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
-- #Rows Exported: 9
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
