 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TFeeStatusTransition
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'D27F3B87-5710-471C-9278-0CA871CFD1B2'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TFeeStatusTransition ON; 
 
        INSERT INTO TFeeStatusTransition([FeeStatusTransitionId], [FeeRefStatusIdFrom], [FeeRefStatusIdTo], [ConcurrencyId])
        SELECT 1,2,3,1 UNION ALL 
        SELECT 2,2,4,1 UNION ALL 
        SELECT 3,2,8,1 UNION ALL 
        SELECT 4,3,4,1 UNION ALL 
        SELECT 5,3,2,1 UNION ALL 
        SELECT 6,3,8,1 UNION ALL 
        SELECT 7,4,5,1 UNION ALL 
        SELECT 8,4,3,1 UNION ALL 
        SELECT 9,4,2,1 UNION ALL 
        SELECT 10,6,7,1 UNION ALL 
        SELECT 11,6,5,1 UNION ALL 
        SELECT 12,4,9,1 UNION ALL 
        SELECT 13,9,4,1 UNION ALL 
        SELECT 14,7,5,1 UNION ALL 
        SELECT 15,2,10,1 UNION ALL 
        SELECT 16,3,10,1 UNION ALL 
        SELECT 17,4,10,1 UNION ALL 
        SELECT 18,10,2,1 UNION ALL 
        SELECT 19,10,8,1 UNION ALL 
        SELECT 20,5,8,1 
 
        SET IDENTITY_INSERT TFeeStatusTransition OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'D27F3B87-5710-471C-9278-0CA871CFD1B2', 
         'Initial load (20 total rows, file 1 of 1) for table TFeeStatusTransition',
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
-- #Rows Exported: 20
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
