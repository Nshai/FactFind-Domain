 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValProviderIndigoClientFrequency
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'BBFE69AE-C47C-4117-AFAF-E02ADD523BC4'
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
        SET IDENTITY_INSERT TValProviderIndigoClientFrequency ON; 
 
        INSERT INTO TValProviderIndigoClientFrequency([ValProviderIndigoClientFrequencyId], [RefProdProviderId], [IndigoClientId], [AllowDaily], [AllowWeekly], [AllowFortnightly], [AllowMonthly], [AllowBiAnnually], [AllowQuarterly], [AllowHalfYearly], [AllowAnnually], [ConcurrencyId])
        SELECT 187,2611,466,1,1,1,1,1,1,1,1,2 UNION ALL 
        SELECT 32293,2334,466,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 41927,2438,466,1,1,1,1,1,1,1,1,3 UNION ALL 
        SELECT 43626,2247,466,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 44742,302,466,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 38316,1509,466,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 14893,2269,466,1,1,1,1,1,1,1,1,2 UNION ALL 
        SELECT 14076,2245,466,1,1,1,1,1,1,1,1,2 UNION ALL 
        SELECT 13259,326,466,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 12442,395,466,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 45858,2313,466,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 35015,1145,466,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 31308,878,466,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 29751,1019,466,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 9991,941,466,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 9174,576,466,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 26415,1814,466,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 8357,321,466,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 7540,84,466,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 24546,1555,466,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 5089,294,466,0,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 20612,1405,466,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 4272,808,466,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 19795,1543,466,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 18978,204,466,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 18161,2610,466,1,1,1,1,1,1,1,1,2 UNION ALL 
        SELECT 17344,310,466,0,1,1,1,1,1,1,1,2 UNION ALL 
        SELECT 16527,62,466,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 15710,1596,466,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 10808,199,466,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 2638,567,466,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 1821,347,466,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 50715,183,466,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 67704,556,466,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 51887,2288,466,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 71535,2572,466,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 55186,1377,466,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 56391,2482,466,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 58991,2215,466,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 64302,901,466,0,1,0,0,0,0,0,0,1 
 
        SET IDENTITY_INSERT TValProviderIndigoClientFrequency OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'BBFE69AE-C47C-4117-AFAF-E02ADD523BC4', 
         'Initial load (40 total rows, file 1 of 1) for table TValProviderIndigoClientFrequency',
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
-- #Rows Exported: 40
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
