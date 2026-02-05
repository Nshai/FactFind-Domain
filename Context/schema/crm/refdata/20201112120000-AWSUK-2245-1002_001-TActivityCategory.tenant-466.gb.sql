 
-----------------------------------------------------------------------------
-- Table: CRM.TActivityCategory
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '3AACAD38-5B4D-4E2F-98DD-04467F5DF352'
     AND TenantId = 466
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
        SELECT 19743, 'Analyse client needs',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19744, 'Correspond with the client',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19745, 'Telephone conversation with the client',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19746, 'Meet with the client',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19747, 'Book appointment with the client',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19748, 'Create client file',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19749, 'Issue terms of business',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19750, 'Prepare report for client',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19751, 'Send report to client',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19752, 'Verify client identification',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19753, 'Give business card to client',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19754, 'Prepare fact find for client',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19755, 'Send fact find to client',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19756, 'Prepare letters of authority/appointment',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19757, 'Signed letters of authority/appointment',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19758, 'Conduct product research',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19759, 'Create suitability letter for client',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19760, 'Obtain and compare product illustrations',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19761, 'Obtain and print key features',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19762, 'Obtain product application form',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19763, 'Pre-complete product application form',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19764, 'Prepare compliance checklist',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19765, 'Present advice to the client',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19766, 'Record compliance file evidence',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19767, 'Record recommendations made to client',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19768, 'Prepare client valuation',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19769, 'Acknowledge receipt of a new application',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19770, 'Arrange doctor appointment for client medical',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19771, 'Complete new business submission form',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19772, 'Confirm underwriting requirements with provider',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19773, 'Issue application form to client',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19774, 'Notify client of underwriting requirements',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19775, 'Reissue incomplete application form to client',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19776, 'Re-submit previously incomplete application',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19777, 'Request additional underwriting forms from client',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19778, 'Submit additional underwriting forms to provider',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19779, 'Submit application to provider',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19780, 'Issue policy documents to client',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19781, 'Correspond with the provider',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19782, 'Telephone conversation with the provider',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19783, 'Meeting',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19784, 'Telephone conversation',1551,0,466,1,1,0,0,0,0, 'Task',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL UNION ALL 
        SELECT 19785, 'Miscellaneous',1552,0,466,1,0,0,0,0,0, 'Diary',0, NULL, NULL,2,0,NULL,1,NULL,NULL,NULL,NULL, NULL 
 
        SET IDENTITY_INSERT TActivityCategory OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '3AACAD38-5B4D-4E2F-98DD-04467F5DF352', 
         'Initial load (43 total rows, file 1 of 1) for table TActivityCategory',
         466, 
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
-- #Rows Exported: 43
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
