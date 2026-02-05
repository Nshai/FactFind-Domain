 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValBulkFrequencyConfig
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '9A9039CE-967E-430D-8546-DABB91CB5B83'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TValBulkFrequencyConfig ON; 
 
        INSERT INTO TValBulkFrequencyConfig([ValBulkFrequencyConfigId], [ValuationProviderId], [AllowDaily], [AllowWeekly], [AllowFortnightly], [AllowMonthly], [AllowBiAnnually], [AllowQuarterly], [AllowHalfYearly], [AllowAnnually], [ConcurrencyId])
        SELECT 1,558,1,0,0,0,0,0,0,0,2 UNION ALL 
        SELECT 2,567,1,0,0,0,0,0,0,0,2 UNION ALL 
        SELECT 3,1543,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 4,1405,1,0,0,0,0,0,0,0,3 UNION ALL 
        SELECT 5,1555,1,0,0,0,0,0,0,0,2 UNION ALL 
        SELECT 6,1814,1,0,0,0,0,0,0,0,2 UNION ALL 
        SELECT 7,1019,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 8,2288,1,0,0,0,0,0,0,0,1 UNION ALL 
        SELECT 9,1377,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 10,1509,1,0,0,0,0,0,0,0,2 UNION ALL 
        SELECT 11,2438,1,0,0,0,0,0,0,0,2 UNION ALL 
        SELECT 12,2247,1,0,0,0,0,0,0,0,1 UNION ALL 
        SELECT 13,302,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 14,2313,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 15,1145,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 16,878,1,0,0,0,0,0,0,0,2 UNION ALL 
        SELECT 17,183,1,0,0,0,0,0,0,0,2 UNION ALL 
        SELECT 18,2215,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 19,901,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 20,556,1,0,0,0,0,0,0,0,2 UNION ALL 
        SELECT 21,2572,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 22,941,1,0,0,0,0,0,0,0,1 UNION ALL 
        SELECT 23,2625,1,0,0,0,0,0,0,0,1 UNION ALL 
        SELECT 24,2432,1,0,0,0,0,0,0,0,1 UNION ALL 
        SELECT 25,1596,1,0,0,0,0,0,0,0,0 UNION ALL 
        SELECT 26,2640,1,0,0,0,0,0,0,0,1 UNION ALL 
        SELECT 27,576,1,0,0,0,0,0,0,0,0 UNION ALL 
        SELECT 28,2377,1,0,0,0,0,0,0,0,1 UNION ALL 
        SELECT 29,181,1,0,0,0,0,0,0,0,1 UNION ALL 
        SELECT 30,1984,1,0,0,0,0,0,0,0,1 UNION ALL 
        SELECT 31,2334,1,0,0,0,0,0,0,0,1 UNION ALL 
        SELECT 32,1796,1,0,0,0,0,0,0,0,1 UNION ALL 
        SELECT 33,2825,1,0,0,0,0,0,0,0,1 UNION ALL 
        SELECT 34,2604,1,0,0,0,0,0,0,0,1 UNION ALL 
        SELECT 35,3070,1,0,0,0,0,0,0,0,1 UNION ALL 
        SELECT 36,2610,1,0,0,0,0,0,0,0,1 
 
        SET IDENTITY_INSERT TValBulkFrequencyConfig OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '9A9039CE-967E-430D-8546-DABB91CB5B83', 
         'Initial load (36 total rows, file 1 of 1) for table TValBulkFrequencyConfig',
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
-- #Rows Exported: 36
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
