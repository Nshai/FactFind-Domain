 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefFeeStatus
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '6FC59A6F-61A8-4A66-8AA5-5D8C96D8E652'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefFeeStatus ON; 
 
        INSERT INTO TRefFeeStatus([RefFeeStatusId], [Name], [ConcurrencyId])
        SELECT 1, 'None',1 UNION ALL 
        SELECT 2, 'Draft',1 UNION ALL 
        SELECT 3, 'Submitted For T & C',1 UNION ALL 
        SELECT 4, 'Due/Active',1 UNION ALL 
        SELECT 5, 'Cancelled',1 UNION ALL 
        SELECT 6, 'Payment Received',1 UNION ALL 
        SELECT 7, 'Paid',1 UNION ALL 
        SELECT 8, 'Deleted',1 UNION ALL 
        SELECT 9, 'Completed',1 UNION ALL 
        SELECT 10, 'NTU',1 
 
        SET IDENTITY_INSERT TRefFeeStatus OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '6FC59A6F-61A8-4A66-8AA5-5D8C96D8E652', 
         'Initial load (10 total rows, file 1 of 1) for table TRefFeeStatus',
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
