 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefPlanAction
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '9527AB0A-BE09-44AE-BFB7-8623FCB71FDD'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPlanAction ON; 
 
        INSERT INTO TRefPlanAction([RefPlanActionId], [Identifier], [Description], [ConcurrencyId], [HideFromLifeCycleDesigner], [LongDescription])
        SELECT 21, 'submitapplication', 'Submit Application',1,1, NULL UNION ALL 
        SELECT 20, 'switchrequest', 'Switch Request',1,0, 'Ability to request a fund switch for a plan, this is dependent on supported Wealthlink providers.' UNION ALL 
        SELECT 12, 'addtopup', 'Add Top-Up',1,0, 'Ability to add a new top-up plan to the existing plan.' UNION ALL 
        SELECT 19, 'changeplanowner', 'Change Plan Owner',1,0, 'Ability to change owner 1 of a plan using the "Change Ownership" action from the plan actions drop down.' UNION ALL 
        SELECT 11, 'editstatuschangedate', 'Edit Status Change Date',1,0, 'Ability to edit the status change date held within the plan history tab of the plan.' UNION ALL 
        SELECT 10, 'editcommissionrate', 'Modify Commission Rate',1,0, 'Ability to modify the Commission rate used against the plan.' UNION ALL 
        SELECT 9, 'filechecking', 'File Checking',1,1, NULL UNION ALL 
        SELECT 8, 'proposals', 'Proposals',1,1, NULL UNION ALL 
        SELECT 7, 'filequeue', 'File Queue',1,1, NULL UNION ALL 
        SELECT 6, 'changesellingadviser', 'Change Selling Adviser',1,0, 'Ability to change the selling adviser of a plan from the plan actions drop down.' UNION ALL 
        SELECT 5, 'changeagencynumber', 'Change Agency Number',1,0, 'Ability to change agency number within the plan Summary tab.' UNION ALL 
        SELECT 4, 'changeprovider', 'Change Provider',1,0, 'Ability to change the provider from the plan actions drop down.' UNION ALL 
        SELECT 3, 'changeprovideraddress', 'Change Provider Address',1,0, 'Ability to change the provider address within the plan Summary tab.' UNION ALL 
        SELECT 2, 'editexpectedcommission', 'Modify Expected Commission',1,0, 'Ability to modify the expected commission within the Commissions tab of a plan.' UNION ALL 
        SELECT 1, 'changeplantype', 'Change Plan Type',1,0, 'Ability to change the plan type from the plan actions drop down.' UNION ALL 
        SELECT 22, 'sellrequest', 'Sell Request',1,1, NULL UNION ALL 
        SELECT 23, 'platformmigration', 'Platform Migration',1,1, 'Platform Migration' 
 
        SET IDENTITY_INSERT TRefPlanAction OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '9527AB0A-BE09-44AE-BFB7-8623FCB71FDD', 
         'Initial load (17 total rows, file 1 of 1) for table TRefPlanAction',
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
-- #Rows Exported: 17
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
