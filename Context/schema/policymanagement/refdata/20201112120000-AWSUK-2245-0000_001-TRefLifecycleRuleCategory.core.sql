 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefLifecycleRuleCategory
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '604BEF61-40AD-4424-96EB-71BE16E9DF9D'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefLifecycleRuleCategory ON; 
 
        INSERT INTO TRefLifecycleRuleCategory([RefLifecycleRuleCategoryId], [CategoryName], [ConcurrencyId])
        SELECT 1, 'Client',1 UNION ALL 
        SELECT 2, 'Fact Find',1 UNION ALL 
        SELECT 3, 'Linked Opportunity',1 UNION ALL 
        SELECT 4, 'Plan',1 UNION ALL 
        SELECT 5, 'Pre-existing Mortgage',1 UNION ALL 
        SELECT 6, 'Pre-existing Opportunity',1 UNION ALL 
        SELECT 7, 'Pre-existing Protection',1 
 
        SET IDENTITY_INSERT TRefLifecycleRuleCategory OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '604BEF61-40AD-4424-96EB-71BE16E9DF9D', 
         'Initial load (7 total rows, file 1 of 1) for table TRefLifecycleRuleCategory',
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
