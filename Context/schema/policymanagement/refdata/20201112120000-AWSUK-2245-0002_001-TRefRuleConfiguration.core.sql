 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefRuleConfiguration
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '1F46647D-0770-4D99-AD5F-A73432F6F4AF'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefRuleConfiguration ON; 
 
        INSERT INTO TRefRuleConfiguration([RefRuleConfigurationId], [RuleName], [RefRuleCategoryId], [DefaultConfiguration])
        SELECT 1, 'Auto create fees for each plan within a service case.User can automatically add fees against each plan within a service case through the Add Fee action',4,0 UNION ALL 
        SELECT 2, 'Change Fee status to due when plan status is updated to Submitted To Provider.This rule will over-ride the security settings for amending the fee status.Fees on pre-existing plans are made due when plan is added',3,0 UNION ALL 
        SELECT 3, 'User can only add fees from Fee Model',2,0 UNION ALL 
        SELECT 4, 'Enable mapping of fee template to plan type functionality',1,0 UNION ALL 
        SELECT 5, 'User should be allowed to link same fees, documents and plans to multiple service cases',4,0 UNION ALL 
        SELECT 6, 'User can only add fees not defined as part of Fee Model',2,0 UNION ALL 
        SELECT 7, 'Modification of VAT exempt and VAT rate not allowed for fee(s) created from fee model in fee details screen',3,0 UNION ALL 
        SELECT 8, 'Modification of instalment details not allowed for fee(s) created from fee model in fee details screen',3,0 UNION ALL 
        SELECT 9, 'Fee model required in Add Client and Add Client and Plan wizard',6,1 UNION ALL 
        SELECT 10, '"Is billable" flag is required in the Add task screen',5,0 UNION ALL 
        SELECT 11, 'Actual Time in Hrs and Mins should be mandatory while completing the task',5,0 UNION ALL 
        SELECT 12, 'Fee invoice can be generated only when the fee status is due',7,1 UNION ALL 
        SELECT 13, 'By default all the tick boxes in the Add Fee screen for adding fees from fee model against a client, plan, service case and task should be checked',2,0 UNION ALL 
        SELECT 14, 'Change Fee status to due when plan status is updated to Inforce.This rule will over-ride the security settings for amending the fee status',3,0 UNION ALL 
        SELECT 15, 'Fee Type is mandatory when adding fee',2,0 UNION ALL 
        SELECT 16, 'Modification of Initial Period on fee details screen is not allowed for fee(s) created from fee model',3,1 UNION ALL 
        SELECT 17, 'By default, VAT is exempt on Add Fee and Create Fee Template screen',2,0 UNION ALL 
        SELECT 18, 'Warning message for Banding Rate and Split definition on Add/Save of Fee details for client paid fee',3,0 
 
        SET IDENTITY_INSERT TRefRuleConfiguration OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '1F46647D-0770-4D99-AD5F-A73432F6F4AF', 
         'Initial load (18 total rows, file 1 of 1) for table TRefRuleConfiguration',
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
-- #Rows Exported: 18
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
