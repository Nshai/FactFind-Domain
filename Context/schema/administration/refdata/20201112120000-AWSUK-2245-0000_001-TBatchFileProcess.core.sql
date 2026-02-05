 
-----------------------------------------------------------------------------
-- Table: Administration.TBatchFileProcess
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '2301B28D-CF02-4053-BE12-1004137C435B'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TBatchFileProcess ON; 
 
        INSERT INTO TBatchFileProcess([BatchFileProcessId], [Name], [Description], [NotificationEmails], [IndigoClientId], [ConcurrencyId], [ApplicationLinkId])
        SELECT 1409, 'Elevate Adviser', 'AXA Elevate Adviser Details List', NULL,1,1,NULL UNION ALL 
        SELECT 1414, 'GCD Batch', 'GCD Batch', '',12748,1,117781 UNION ALL 
        SELECT 1415, 'FPF Batch', 'FPF Batch', '',12748,1,117782 UNION ALL 
        SELECT 1416, 'CAW Batch', 'Contributions and Withdrawals Batch', '',12748,1,117787 UNION ALL 
        SELECT 1417, 'GCD Batch', 'GCD Batch', '',13590,1,147935 UNION ALL 
        SELECT 1418, 'FPF Batch', 'FPF Batch', '',13590,1,147936 UNION ALL 
        SELECT 1419, 'CAW Batch', 'Contributions and Withdrawals Batch', '',13590,1,147941 
 
        SET IDENTITY_INSERT TBatchFileProcess OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '2301B28D-CF02-4053-BE12-1004137C435B', 
         'Initial load (7 total rows, file 1 of 1) for table TBatchFileProcess',
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
-- #Rows Exported: 7
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
