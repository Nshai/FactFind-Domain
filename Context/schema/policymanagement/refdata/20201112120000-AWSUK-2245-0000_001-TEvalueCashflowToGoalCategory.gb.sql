 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TEvalueCashflowToGoalCategory
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'C13B8EB7-8F03-4FC8-A45A-0C1CF1169168'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TEvalueCashflowToGoalCategory ON; 
 
        INSERT INTO TEvalueCashflowToGoalCategory([EvalueCashflowToGoalCategoryId], [RefEvalueCashflowTypeId], [RefGoalCategoryId], [ConcurrencyId])
        SELECT 1,1,1,1 UNION ALL 
        SELECT 2,2,2,1 UNION ALL 
        SELECT 3,3,3,1 UNION ALL 
        SELECT 4,4,4,1 UNION ALL 
        SELECT 5,5,5,1 UNION ALL 
        SELECT 6,6,7,1 UNION ALL 
        SELECT 7,34,6,1 UNION ALL 
        SELECT 8,34,8,1 UNION ALL 
        SELECT 9,1,1,1 UNION ALL 
        SELECT 10,2,2,1 UNION ALL 
        SELECT 11,3,3,1 UNION ALL 
        SELECT 12,4,4,1 UNION ALL 
        SELECT 13,5,5,1 UNION ALL 
        SELECT 14,6,7,1 UNION ALL 
        SELECT 15,34,6,1 UNION ALL 
        SELECT 16,1,1,1 UNION ALL 
        SELECT 17,2,2,1 UNION ALL 
        SELECT 18,3,3,1 UNION ALL 
        SELECT 19,4,4,1 UNION ALL 
        SELECT 20,5,5,1 UNION ALL 
        SELECT 21,6,7,1 UNION ALL 
        SELECT 22,34,6,1 
 
        SET IDENTITY_INSERT TEvalueCashflowToGoalCategory OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'C13B8EB7-8F03-4FC8-A45A-0C1CF1169168', 
         'Initial load (22 total rows, file 1 of 1) for table TEvalueCashflowToGoalCategory',
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
-- #Rows Exported: 22
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
