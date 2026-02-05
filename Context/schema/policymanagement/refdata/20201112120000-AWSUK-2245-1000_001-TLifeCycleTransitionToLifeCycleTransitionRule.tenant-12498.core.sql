 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TLifeCycleTransitionToLifeCycleTransitionRule
--    Join: join TLifeCycleTransition t on t.LifeCycleTransitionId = TLifeCycleTransitionToLifeCycleTransitionRule.LifeCycleTransitionId join tlifecyclestep s on s.LifeCycleStepId = t.LifeCycleStepId join tlifecycle l on l.LifeCycleId = s.LifeCycleId
--   Where: WHERE l.IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '8AD6F797-F0AA-46DF-88FA-1878356CB04A'
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
        SET IDENTITY_INSERT TLifeCycleTransitionToLifeCycleTransitionRule ON; 
 
        INSERT INTO TLifeCycleTransitionToLifeCycleTransitionRule([LifeCycleTransitionToLifeCycleTransitionRuleId], [LifeCycleTransitionId], [LifeCycleTransitionRuleId], [ConcurrencyId])
        SELECT 238884,855420,6,1 UNION ALL 
        SELECT 238891,855461,6,1 UNION ALL 
        SELECT 238896,855483,6,1 UNION ALL 
        SELECT 238902,855499,6,1 UNION ALL 
        SELECT 238909,855438,6,1 UNION ALL 
        SELECT 238916,855413,6,1 UNION ALL 
        SELECT 243494,855424,53,1 UNION ALL 
        SELECT 243495,855424,14,1 UNION ALL 
        SELECT 243496,855424,15,1 UNION ALL 
        SELECT 243497,855466,53,1 UNION ALL 
        SELECT 243498,855466,14,1 UNION ALL 
        SELECT 243499,855466,15,1 UNION ALL 
        SELECT 243500,855487,53,1 UNION ALL 
        SELECT 243501,855487,14,1 UNION ALL 
        SELECT 243502,855487,15,1 UNION ALL 
        SELECT 243503,855503,53,1 UNION ALL 
        SELECT 243504,855503,14,1 UNION ALL 
        SELECT 243505,855503,15,1 UNION ALL 
        SELECT 243506,855443,53,1 UNION ALL 
        SELECT 243507,855443,14,1 UNION ALL 
        SELECT 243508,855443,15,1 UNION ALL 
        SELECT 248806,904937,6,1 UNION ALL 
        SELECT 248807,904941,53,1 UNION ALL 
        SELECT 248808,904941,14,1 UNION ALL 
        SELECT 248809,904941,15,1 UNION ALL 
        SELECT 248814,904954,6,1 UNION ALL 
        SELECT 248815,904958,53,1 UNION ALL 
        SELECT 248816,904958,14,1 UNION ALL 
        SELECT 248817,904958,15,1 
 
        SET IDENTITY_INSERT TLifeCycleTransitionToLifeCycleTransitionRule OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '8AD6F797-F0AA-46DF-88FA-1878356CB04A', 
         'Initial load (29 total rows, file 1 of 1) for table TLifeCycleTransitionToLifeCycleTransitionRule',
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
-- #Rows Exported: 29
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
