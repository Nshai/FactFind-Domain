 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TEvalueCashflowToExpenditureCategory
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '1869624A-5473-4EB1-B91A-0BF51FA0ADD4'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TEvalueCashflowToExpenditureCategory ON; 
 
        INSERT INTO TEvalueCashflowToExpenditureCategory([EvalueCashflowToExpenditureCategoryId], [RefExpenditureTypeId], [RefEvalueCashflowTypeId])
        SELECT 1,6,7 UNION ALL 
        SELECT 2,4,7 UNION ALL 
        SELECT 3,5,7 UNION ALL 
        SELECT 4,7,8 UNION ALL 
        SELECT 5,2,9 UNION ALL 
        SELECT 6,3,10 UNION ALL 
        SELECT 7,8,11 UNION ALL 
        SELECT 8,9,13 UNION ALL 
        SELECT 9,11,14 UNION ALL 
        SELECT 10,13,21 UNION ALL 
        SELECT 11,18,25 UNION ALL 
        SELECT 12,19,26 UNION ALL 
        SELECT 13,17,29 UNION ALL 
        SELECT 15,10,31 UNION ALL 
        SELECT 16,20,33 UNION ALL 
        SELECT 17,23,9 UNION ALL 
        SELECT 18,24,12 UNION ALL 
        SELECT 19,25,23 UNION ALL 
        SELECT 23,12,18 UNION ALL 
        SELECT 24,21,33 UNION ALL 
        SELECT 25,22,33 UNION ALL 
        SELECT 26,1,33 UNION ALL 
        SELECT 27,14,13 UNION ALL 
        SELECT 28,26,13 UNION ALL 
        SELECT 29,16,33 UNION ALL 
        SELECT 30,31,33 UNION ALL 
        SELECT 31,30,33 UNION ALL 
        SELECT 32,36,33 UNION ALL 
        SELECT 33,37,33 UNION ALL 
        SELECT 34,38,33 UNION ALL 
        SELECT 35,39,33 
 
        SET IDENTITY_INSERT TEvalueCashflowToExpenditureCategory OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '1869624A-5473-4EB1-B91A-0BF51FA0ADD4', 
         'Initial load (31 total rows, file 1 of 1) for table TEvalueCashflowToExpenditureCategory',
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
-- #Rows Exported: 31
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
