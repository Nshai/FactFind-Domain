 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValMatchingCriteria
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'CC2BA421-C2FB-4DEC-9BB6-DEAB46BCE0C0'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TValMatchingCriteria ON; 
 
        INSERT INTO TValMatchingCriteria([ValMatchingCriteriaId], [ValuationProviderId], [MatchingMask], [ConcurrencyId])
        SELECT 1,567,16,1 UNION ALL 
        SELECT 2,558,50193,1 UNION ALL 
        SELECT 3,1543,16,1 UNION ALL 
        SELECT 4,1405,16,3 UNION ALL 
        SELECT 5,1814,16,1 UNION ALL 
        SELECT 6,2288,16,1 UNION ALL 
        SELECT 7,1377,16,1 UNION ALL 
        SELECT 8,1509,16,1 UNION ALL 
        SELECT 9,2247,16,1 UNION ALL 
        SELECT 10,302,16,1 UNION ALL 
        SELECT 11,2313,16,1 UNION ALL 
        SELECT 12,183,16,1 UNION ALL 
        SELECT 13,2215,16,1 UNION ALL 
        SELECT 14,901,16,1 UNION ALL 
        SELECT 15,1555,16,1 UNION ALL 
        SELECT 16,1019,18,1 UNION ALL 
        SELECT 17,878,17,1 UNION ALL 
        SELECT 18,1145,83,1 UNION ALL 
        SELECT 19,2438,19,1 UNION ALL 
        SELECT 20,556,16,1 UNION ALL 
        SELECT 21,2572,2064,1 UNION ALL 
        SELECT 22,62,16,1 UNION ALL 
        SELECT 23,84,16,1 UNION ALL 
        SELECT 25,199,16,1 UNION ALL 
        SELECT 26,204,16,1 UNION ALL 
        SELECT 27,310,16,2 UNION ALL 
        SELECT 28,294,16,1 UNION ALL 
        SELECT 29,321,16,1 UNION ALL 
        SELECT 31,326,16,1 UNION ALL 
        SELECT 32,2611,16,2 UNION ALL 
        SELECT 33,347,16,1 UNION ALL 
        SELECT 34,395,16,1 UNION ALL 
        SELECT 35,576,16,2 UNION ALL 
        SELECT 36,808,16,1 UNION ALL 
        SELECT 37,941,32784,2 UNION ALL 
        SELECT 38,1596,16,2 UNION ALL 
        SELECT 39,2610,19,2 UNION ALL 
        SELECT 40,2245,16,1 UNION ALL 
        SELECT 42,2269,16,1 UNION ALL 
        SELECT 44,2482,16,1 UNION ALL 
        SELECT 45,2432,16,1 UNION ALL 
        SELECT 46,2625,16,1 UNION ALL 
        SELECT 47,2640,18,1 UNION ALL 
        SELECT 48,2377,16,1 UNION ALL 
        SELECT 49,181,17,1 UNION ALL 
        SELECT 50,1984,16,1 UNION ALL 
        SELECT 51,2334,65552,1 UNION ALL 
        SELECT 52,1796,16,1 UNION ALL 
        SELECT 53,2825,16,1 UNION ALL 
        SELECT 54,2604,16,1 UNION ALL 
        SELECT 55,3070,16,1 
 
        SET IDENTITY_INSERT TValMatchingCriteria OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'CC2BA421-C2FB-4DEC-9BB6-DEAB46BCE0C0', 
         'Initial load (51 total rows, file 1 of 1) for table TValMatchingCriteria',
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
