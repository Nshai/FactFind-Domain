 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValEligibilityCriteria
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'F143EF0D-F9FF-4BC5-A6AF-DBBB653B08CB'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TValEligibilityCriteria ON; 
 
        INSERT INTO TValEligibilityCriteria([ValEligibilityCriteriaId], [ValuationProviderId], [EligibilityMask], [ConcurrencyId])
        SELECT 1,62,3135,1 UNION ALL 
        SELECT 2,84,3135,1 UNION ALL 
        SELECT 4,183,3135,1 UNION ALL 
        SELECT 5,199,3135,1 UNION ALL 
        SELECT 6,204,3135,1 UNION ALL 
        SELECT 7,310,3135,2 UNION ALL 
        SELECT 8,294,3135,1 UNION ALL 
        SELECT 9,302,1087,1 UNION ALL 
        SELECT 10,321,3135,1 UNION ALL 
        SELECT 12,326,3135,1 UNION ALL 
        SELECT 13,2611,3135,2 UNION ALL 
        SELECT 14,347,3135,1 UNION ALL 
        SELECT 15,395,3135,1 UNION ALL 
        SELECT 16,576,1087,2 UNION ALL 
        SELECT 17,808,3135,1 UNION ALL 
        SELECT 18,878,1087,1 UNION ALL 
        SELECT 19,901,1087,1 UNION ALL 
        SELECT 20,941,3135,1 UNION ALL 
        SELECT 21,1019,1087,1 UNION ALL 
        SELECT 22,1145,1087,1 UNION ALL 
        SELECT 23,1377,1087,1 UNION ALL 
        SELECT 24,1405,1087,1 UNION ALL 
        SELECT 25,1509,1087,1 UNION ALL 
        SELECT 26,1543,1087,1 UNION ALL 
        SELECT 27,1555,1087,1 UNION ALL 
        SELECT 28,1596,1087,2 UNION ALL 
        SELECT 29,1814,1087,1 UNION ALL 
        SELECT 30,2610,1087,2 UNION ALL 
        SELECT 31,2215,1087,1 UNION ALL 
        SELECT 32,2245,3135,1 UNION ALL 
        SELECT 33,2247,1087,1 UNION ALL 
        SELECT 35,2269,3135,1 UNION ALL 
        SELECT 36,2288,1087,1 UNION ALL 
        SELECT 37,2313,1087,1 UNION ALL 
        SELECT 38,2334,3135,1 UNION ALL 
        SELECT 39,2438,1087,1 UNION ALL 
        SELECT 40,2482,3135,1 UNION ALL 
        SELECT 41,567,3135,2 UNION ALL 
        SELECT 42,558,3134,1 UNION ALL 
        SELECT 43,556,1087,1 UNION ALL 
        SELECT 44,2572,559,1 UNION ALL 
        SELECT 45,2432,1087,1 UNION ALL 
        SELECT 46,2625,1087,1 UNION ALL 
        SELECT 47,2640,1087,1 UNION ALL 
        SELECT 48,2377,1087,1 UNION ALL 
        SELECT 49,181,1087,1 UNION ALL 
        SELECT 50,1984,1087,1 UNION ALL 
        SELECT 52,1796,1087,1 UNION ALL 
        SELECT 53,2825,1087,1 UNION ALL 
        SELECT 54,2604,1087,1 UNION ALL 
        SELECT 55,3070,1087,1 
 
        SET IDENTITY_INSERT TValEligibilityCriteria OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'F143EF0D-F9FF-4BC5-A6AF-DBBB653B08CB', 
         'Initial load (51 total rows, file 1 of 1) for table TValEligibilityCriteria',
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
-- #Rows Exported: 51
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
