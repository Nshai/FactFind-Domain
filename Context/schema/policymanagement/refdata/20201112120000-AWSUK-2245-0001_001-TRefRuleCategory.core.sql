 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefRuleCategory
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '745AE2CB-68BD-4937-9797-A6F4CFA5649E'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefRuleCategory ON; 
 
        INSERT INTO TRefRuleCategory([RefRuleCategoryId], [Name], [ConcurrencyId])
        SELECT 1, 'Fee Model',1 UNION ALL 
        SELECT 2, 'Add Fee Wizard',1 UNION ALL 
        SELECT 3, 'Fee Details Screen',1 UNION ALL 
        SELECT 4, 'Service Cases',1 UNION ALL 
        SELECT 5, 'Task',1 UNION ALL 
        SELECT 6, 'Add Client Wizard',1 UNION ALL 
        SELECT 7, 'Fee Invoice',1 
 
        SET IDENTITY_INSERT TRefRuleCategory OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '745AE2CB-68BD-4937-9797-A6F4CFA5649E', 
         'Initial load (7 total rows, file 1 of 1) for table TRefRuleCategory',
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
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
