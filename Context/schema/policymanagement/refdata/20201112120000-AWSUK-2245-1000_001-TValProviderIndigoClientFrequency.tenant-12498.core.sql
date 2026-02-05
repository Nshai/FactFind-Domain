 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValProviderIndigoClientFrequency
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'BBFE69AE-C47C-4117-AFAF-E02ADD523BC4'
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
        SET IDENTITY_INSERT TValProviderIndigoClientFrequency ON; 
 
        INSERT INTO TValProviderIndigoClientFrequency([ValProviderIndigoClientFrequencyId], [RefProdProviderId], [IndigoClientId], [AllowDaily], [AllowWeekly], [AllowFortnightly], [AllowMonthly], [AllowBiAnnually], [AllowQuarterly], [AllowHalfYearly], [AllowAnnually], [ConcurrencyId])
        SELECT 138284,2611,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138286,347,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138287,567,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138289,808,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138290,294,12498,0,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138292,84,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138293,321,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138294,576,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138295,941,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138296,199,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138298,395,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138299,326,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138300,2245,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138301,2269,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138302,1596,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138303,62,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138304,310,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138305,2610,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138306,204,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138307,1543,12498,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 138308,1405,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138309,1555,12498,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 138310,1814,12498,1,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 138311,1019,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138312,878,12498,0,1,0,0,0,0,0,0,1 UNION ALL 
        SELECT 138313,2334,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138314,1145,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138315,1509,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138316,2438,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138317,2247,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138318,302,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138319,2313,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138320,183,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138321,2288,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138322,1377,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138323,2482,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138324,2215,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138325,901,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138326,556,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138327,2572,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138328,2625,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138329,2432,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138330,2640,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138331,2377,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138332,181,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138333,1984,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138334,1796,12498,1,1,1,1,1,1,1,1,1 UNION ALL 
        SELECT 138335,2825,12498,1,1,1,1,1,1,1,1,1 
 
        SET IDENTITY_INSERT TValProviderIndigoClientFrequency OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'BBFE69AE-C47C-4117-AFAF-E02ADD523BC4', 
         'Initial load (48 total rows, file 1 of 1) for table TValProviderIndigoClientFrequency',
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
-- #Rows Exported: 48
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
