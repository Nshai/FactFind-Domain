 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TLifeCycleStep
--    Join: join TLifecycle l on l.LifeCycleId = TLifeCycleStep.LifeCycleId
--   Where: WHERE l.IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '762D0AF0-FDE9-4AE7-8FD0-103618EA14DD'
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
        SET IDENTITY_INSERT TLifeCycleStep ON; 
 
        INSERT INTO TLifeCycleStep([LifeCycleStepId], [StatusId], [LifeCycleId], [ConcurrencyId], [IsSystem])
        SELECT 46458,3872,6304,1,0 UNION ALL 
        SELECT 46459,3869,6304,1,0 UNION ALL 
        SELECT 46460,3874,6304,1,0 UNION ALL 
        SELECT 119406,17213,6304,1,0 UNION ALL 
        SELECT 46461,3870,6305,1,0 UNION ALL 
        SELECT 46462,3869,6305,1,0 UNION ALL 
        SELECT 46463,3878,6305,1,0 UNION ALL 
        SELECT 46464,3877,6305,1,0 UNION ALL 
        SELECT 46465,3873,6305,1,0 UNION ALL 
        SELECT 46466,3872,6305,1,0 UNION ALL 
        SELECT 46467,3874,6305,1,0 UNION ALL 
        SELECT 119407,17213,6305,1,0 UNION ALL 
        SELECT 46468,3870,6306,1,0 UNION ALL 
        SELECT 46469,3869,6306,1,0 UNION ALL 
        SELECT 46470,3878,6306,1,0 UNION ALL 
        SELECT 46471,3877,6306,1,0 UNION ALL 
        SELECT 46472,3873,6306,1,0 UNION ALL 
        SELECT 46473,3879,6306,1,0 UNION ALL 
        SELECT 46474,3872,6306,1,0 UNION ALL 
        SELECT 46475,3874,6306,1,0 UNION ALL 
        SELECT 119408,17213,6306,1,0 UNION ALL 
        SELECT 46476,3870,6307,1,0 UNION ALL 
        SELECT 46477,3869,6307,1,0 UNION ALL 
        SELECT 46478,3876,6307,1,0 UNION ALL 
        SELECT 46479,3878,6307,1,0 UNION ALL 
        SELECT 46480,3877,6307,1,0 UNION ALL 
        SELECT 46481,3873,6307,1,0 UNION ALL 
        SELECT 46482,3875,6307,1,0 UNION ALL 
        SELECT 46483,3872,6307,1,0 UNION ALL 
        SELECT 46484,3874,6307,1,0 UNION ALL 
        SELECT 119409,17213,6307,1,0 UNION ALL 
        SELECT 46485,3872,6308,1,0 UNION ALL 
        SELECT 46486,3877,6308,1,0 UNION ALL 
        SELECT 46487,3874,6308,1,0 UNION ALL 
        SELECT 46488,3871,6308,1,0 UNION ALL 
        SELECT 46489,3870,6308,1,0 UNION ALL 
        SELECT 46490,3873,6308,1,0 UNION ALL 
        SELECT 46491,3869,6308,1,0 UNION ALL 
        SELECT 46492,3878,6308,1,0 UNION ALL 
        SELECT 119410,17213,6308,1,0 UNION ALL 
        SELECT 184178,3869,22437,1,1 UNION ALL 
        SELECT 184179,3870,22437,1,1 UNION ALL 
        SELECT 184180,3872,22437,1,1 UNION ALL 
        SELECT 184181,3873,22437,1,1 UNION ALL 
        SELECT 184182,3874,22437,1,1 UNION ALL 
        SELECT 184183,17213,22437,1,1 UNION ALL 
        SELECT 184184,3877,22437,1,1 UNION ALL 
        SELECT 264970,3869,32779,1,1 UNION ALL 
        SELECT 264971,3870,32779,1,1 UNION ALL 
        SELECT 264972,3872,32779,1,1 UNION ALL 
        SELECT 264973,3874,32779,1,1 UNION ALL 
        SELECT 264974,17213,32779,1,1 UNION ALL 
        SELECT 264975,3877,32779,1,1 
 
        SET IDENTITY_INSERT TLifeCycleStep OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '762D0AF0-FDE9-4AE7-8FD0-103618EA14DD', 
         'Initial load (53 total rows, file 1 of 1) for table TLifeCycleStep',
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
-- #Rows Exported: 53
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
