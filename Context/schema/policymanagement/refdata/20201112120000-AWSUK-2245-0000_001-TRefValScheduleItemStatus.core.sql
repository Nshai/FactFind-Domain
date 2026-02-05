 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefValScheduleItemStatus
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'AB07680F-2052-4128-99A7-C0044826C75E'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefValScheduleItemStatus ON; 
 
        INSERT INTO TRefValScheduleItemStatus([RefValScheduleItemStatusId], [Identifier], [ConcurrencyId])
        SELECT 1, 'Download',1 UNION ALL 
        SELECT 2, 'Downloading',1 UNION ALL 
        SELECT 3, 'DownloadCompleted',1 UNION ALL 
        SELECT 4, 'DownloadFailed',1 UNION ALL 
        SELECT 5, 'Process',1 UNION ALL 
        SELECT 6, 'Processing',1 UNION ALL 
        SELECT 7, 'ProcessCompleted',1 UNION ALL 
        SELECT 8, 'ProcessFailed',1 UNION ALL 
        SELECT 9, 'DownloadRequested',1 UNION ALL 
        SELECT 10, 'ProcessIncompletePleaseRetry',1 
 
        SET IDENTITY_INSERT TRefValScheduleItemStatus OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'AB07680F-2052-4128-99A7-C0044826C75E', 
         'Initial load (10 total rows, file 1 of 1) for table TRefValScheduleItemStatus',
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
-- #Rows Exported: 10
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
