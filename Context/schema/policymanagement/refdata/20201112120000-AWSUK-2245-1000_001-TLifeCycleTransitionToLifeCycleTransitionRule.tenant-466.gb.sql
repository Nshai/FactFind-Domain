 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TLifeCycleTransitionToLifeCycleTransitionRule
--    Join: join TLifeCycleTransition t on t.LifeCycleTransitionId = TLifeCycleTransitionToLifeCycleTransitionRule.LifeCycleTransitionId join tlifecyclestep s on s.LifeCycleStepId = t.LifeCycleStepId join tlifecycle l on l.LifeCycleId = s.LifeCycleId
--   Where: WHERE l.IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '8AD6F797-F0AA-46DF-88FA-1878356CB04A'
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
        SET IDENTITY_INSERT TLifeCycleTransitionToLifeCycleTransitionRule ON; 
 
        INSERT INTO TLifeCycleTransitionToLifeCycleTransitionRule([LifeCycleTransitionToLifeCycleTransitionRuleId], [LifeCycleTransitionId], [LifeCycleTransitionRuleId], [ConcurrencyId])
        SELECT 30236,92227,6,1 UNION ALL 
        SELECT 45469,92227,22,1 UNION ALL 
        SELECT 45470,92230,22,1 UNION ALL 
        SELECT 139484,92230,6,1 UNION ALL 
        SELECT 30237,92231,6,1 UNION ALL 
        SELECT 45471,92231,22,1 UNION ALL 
        SELECT 30238,92232,4,1 UNION ALL 
        SELECT 30239,92232,3,1 UNION ALL 
        SELECT 30240,92232,5,1 UNION ALL 
        SELECT 30243,92232,2,1 UNION ALL 
        SELECT 30244,92232,7,1 UNION ALL 
        SELECT 30245,92233,4,1 UNION ALL 
        SELECT 30246,92233,3,1 UNION ALL 
        SELECT 30247,92233,5,1 UNION ALL 
        SELECT 30250,92233,2,1 UNION ALL 
        SELECT 30251,92233,7,1 UNION ALL 
        SELECT 30252,92236,6,1 UNION ALL 
        SELECT 30253,92237,6,1 UNION ALL 
        SELECT 30254,92245,6,1 UNION ALL 
        SELECT 45472,92245,22,1 UNION ALL 
        SELECT 30255,92246,4,1 UNION ALL 
        SELECT 30256,92246,3,1 UNION ALL 
        SELECT 30257,92246,5,1 UNION ALL 
        SELECT 30260,92246,2,1 UNION ALL 
        SELECT 30261,92246,7,1 UNION ALL 
        SELECT 30262,92247,4,1 UNION ALL 
        SELECT 30263,92247,3,1 UNION ALL 
        SELECT 30264,92247,5,1 UNION ALL 
        SELECT 30267,92247,2,1 UNION ALL 
        SELECT 30307,92247,7,1 UNION ALL 
        SELECT 30308,92250,6,1 UNION ALL 
        SELECT 101210,92251,6,1 UNION ALL 
        SELECT 45473,92263,22,1 UNION ALL 
        SELECT 101211,92263,6,1 UNION ALL 
        SELECT 101212,92265,4,1 UNION ALL 
        SELECT 101213,92265,3,1 UNION ALL 
        SELECT 101214,92265,5,1 UNION ALL 
        SELECT 101217,92265,2,1 UNION ALL 
        SELECT 101218,92265,7,1 UNION ALL 
        SELECT 84892,92266,4,1 UNION ALL 
        SELECT 84893,92266,3,1 UNION ALL 
        SELECT 84894,92266,5,1 UNION ALL 
        SELECT 84897,92266,2,1 UNION ALL 
        SELECT 84898,92266,7,1 UNION ALL 
        SELECT 84899,92270,6,1 UNION ALL 
        SELECT 84900,92271,6,1 UNION ALL 
        SELECT 30309,92283,6,1 UNION ALL 
        SELECT 84901,92284,6,1 UNION ALL 
        SELECT 45474,92288,22,1 UNION ALL 
        SELECT 84902,92288,6,1 UNION ALL 
        SELECT 84903,92289,4,1 UNION ALL 
        SELECT 84904,92289,3,1 UNION ALL 
        SELECT 84905,92289,5,1 UNION ALL 
        SELECT 84908,92289,2,1 UNION ALL 
        SELECT 84909,92289,7,1 UNION ALL 
        SELECT 84910,92290,4,1 UNION ALL 
        SELECT 84911,92290,3,1 UNION ALL 
        SELECT 84912,92290,5,1 UNION ALL 
        SELECT 84915,92290,2,1 UNION ALL 
        SELECT 84916,92290,7,1 
 
        SET IDENTITY_INSERT TLifeCycleTransitionToLifeCycleTransitionRule OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '8AD6F797-F0AA-46DF-88FA-1878356CB04A', 
         'Initial load (60 total rows, file 1 of 1) for table TLifeCycleTransitionToLifeCycleTransitionRule',
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
-- #Rows Exported: 60
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
