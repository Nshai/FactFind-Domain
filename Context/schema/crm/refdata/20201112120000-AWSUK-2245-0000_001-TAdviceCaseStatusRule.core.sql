 
-----------------------------------------------------------------------------
-- Table: CRM.TAdviceCaseStatusRule
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '012F5B7B-38B8-4978-A325-1AEF6AE35569'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TAdviceCaseStatusRule ON; 
 
        INSERT INTO TAdviceCaseStatusRule([AdviceCaseStatusRuleId], [RuleDescriptor], [ActionDescriptor], [IsArchived], [ConcurrencyId])
        SELECT 1, 'Check if a binder is related to the service case', 'A binder must be related to the Service Case',0,1 UNION ALL 
        SELECT 2, 'Check if the binder related to the service case is at status of ''Sent to Client''', 'The related binder must be at the status of ''Sent to Client''',0,1 UNION ALL 
        SELECT 3, 'Check if the binder related to the service case contains the final version of fact find', 'Binder associated to the service case must have a final version of Fact find document',0,1 
 
        SET IDENTITY_INSERT TAdviceCaseStatusRule OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '012F5B7B-38B8-4978-A325-1AEF6AE35569', 
         'Initial load (3 total rows, file 1 of 1) for table TAdviceCaseStatusRule',
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
-- #Rows Exported: 3
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
