 
-----------------------------------------------------------------------------
-- Table: CRM.TActivityCategory
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '3AACAD38-5B4D-4E2F-98DD-04467F5DF352'
     AND TenantId = 12498
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TActivityCategory ON; 
 
        INSERT INTO TActivityCategory([ActivityCategoryId], [Name], [ActivityCategoryParentId], [LifeCycleTransitionId], [IndigoClientId], [ClientRelatedFG], [PlanRelatedFG], [FeeRelatedFG], [RetainerRelatedFG], [OpportunityRelatedFG], [AdviserRelatedFg], [ActivityEvent], [RefSystemEventId], [TemplateTypeId], [TemplateId], [ConcurrencyId], [IsArchived], [GroupId], [IsPropagated], [TaskBillingRate], [EstimatedTimeHrs], [EstimatedTimeMins], [DocumentDesignerTemplateId], [Description])
        SELECT 283431, 'Contact Prospect and Qualify Lead',27372,0,12498,0,0,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, '1. Contact Prospect
2. Add Opportunity(ies)
3. Qualify Lead 
4. Book First Appointment
5. Update Prospect Status' UNION ALL 
        SELECT 283432, 'Issue Welcome Email with PFP registration',27373,0,12498,0,0,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 283433, 'Complete EIDV',27373,0,12498,0,0,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, 'On receipt of Passport and/or Driving Licence, complete EIDV' UNION ALL 
        SELECT 283434, 'Book Appointment',27374,0,12498,0,0,0,0,0,0, 'Task',0, NULL, NULL,1,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 283435, 'Finalise Fact Find',27374,0,12498,0,0,0,0,0,0, 'Task',0, NULL, NULL,1,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 283436, 'Analyse Client''s Need and Research',27374,0,12498,0,0,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 283437, 'Suitability Report',27374,0,12498,0,0,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 283485, 'Fund Switch',27382,0,12498,0,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, '1. Obtain switch authorisation from client
2. Once receipt action online to send to provider
3. Confirm actioned by provider, obtain real time valuation (if application)
4. Send confirmation to client' UNION ALL 
        SELECT 283487, 'New Business Processing',27383,0,12498,0,0,0,0,0,0, 'Task',0, NULL, NULL,3,0,NULL,1,NULL,NULL,NULL,NULL, 'This activity/task should be left open and diarised accordingly to record all actions taken to issue the plan.  The task reference should be used to reflect current status eg Await Policy Documents etc' UNION ALL 
        SELECT 294746, 'Client Review',27382,0,12498,1,0,0,0,0,0, 'Task',0, NULL, NULL,1,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 317753, 'Appointment',27382,0,12498,1,0,0,0,0,0, 'Diary',0, NULL, NULL,1,0,NULL,1,NULL,NULL,NULL,NULL, NULL 
 
        SET IDENTITY_INSERT TActivityCategory OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '3AACAD38-5B4D-4E2F-98DD-04467F5DF352', 
         'Initial load (11 total rows, file 1 of 1) for table TActivityCategory',
         12498, 
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
-- #Rows Exported: 11
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
