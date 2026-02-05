 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValLookUp
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '4E81D2BC-54A5-40BF-9B33-DD2C3C756DA7'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TValLookUp ON; 
 
        INSERT INTO TValLookUp([ValLookUpId], [RefProdProviderId], [MappedRefProdProviderId], [ConcurrencyId])
        SELECT 1,121,567,1 UNION ALL 
        SELECT 2,122,567,1 UNION ALL 
        SELECT 5,349,395,1 UNION ALL 
        SELECT 6,1080,321,1 UNION ALL 
        SELECT 7,348,347,1 UNION ALL 
        SELECT 8,1071,347,1 UNION ALL 
        SELECT 9,1416,347,1 UNION ALL 
        SELECT 10,1367,395,1 UNION ALL 
        SELECT 11,1051,395,1 UNION ALL 
        SELECT 12,1665,395,1 UNION ALL 
        SELECT 13,430,62,1 UNION ALL 
        SELECT 15,256,808,1 UNION ALL 
        SELECT 18,2120,204,1 UNION ALL 
        SELECT 19,2209,204,1 UNION ALL 
        SELECT 21,296,1543,1 UNION ALL 
        SELECT 22,712,1543,1 UNION ALL 
        SELECT 23,1078,1555,1 UNION ALL 
        SELECT 24,1933,2245,1 UNION ALL 
        SELECT 25,389,2245,1 UNION ALL 
        SELECT 26,600,321,1 UNION ALL 
        SELECT 27,220,2269,1 UNION ALL 
        SELECT 30,2182,347,1 UNION ALL 
        SELECT 33,1428,183,1 UNION ALL 
        SELECT 34,60,2288,1 UNION ALL 
        SELECT 35,313,2288,1 UNION ALL 
        SELECT 36,507,2288,1 UNION ALL 
        SELECT 37,827,2288,1 UNION ALL 
        SELECT 38,845,2288,1 UNION ALL 
        SELECT 39,930,2288,1 UNION ALL 
        SELECT 40,1228,2288,1 UNION ALL 
        SELECT 41,2356,2288,1 UNION ALL 
        SELECT 42,88,2215,1 UNION ALL 
        SELECT 43,89,2215,1 UNION ALL 
        SELECT 44,2216,2215,1 UNION ALL 
        SELECT 45,706,556,1 UNION ALL 
        SELECT 46,2530,1543,1 UNION ALL 
        SELECT 47,2029,2610,1 UNION ALL 
        SELECT 48,335,2611,1 UNION ALL 
        SELECT 50,2626,556,1 UNION ALL 
        SELECT 51,2186,2640,1 UNION ALL 
        SELECT 52,2414,2377,1 UNION ALL 
        SELECT 53,236,310,1 UNION ALL 
        SELECT 54,20,1796,1 UNION ALL 
        SELECT 55,2908,2245,1 UNION ALL 
        SELECT 56,707,2604,1 UNION ALL 
        SELECT 57,2297,1555,1 UNION ALL 
        SELECT 58,2719,347,1 UNION ALL 
        SELECT 59,2266,808,1 UNION ALL 
        SELECT 60,25,808,1 UNION ALL 
        SELECT 61,28,808,1 UNION ALL 
        SELECT 62,3028,2377,1 UNION ALL 
        SELECT 63,133,808,1 UNION ALL 
        SELECT 64,3054,2377,1 UNION ALL 
        SELECT 65,3181,2640,1 UNION ALL 
        SELECT 66,2933,2640,1 UNION ALL 
        SELECT 67,558,3070,1 UNION ALL 
        SELECT 68,3480,2377,1 
 
        SET IDENTITY_INSERT TValLookUp OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '4E81D2BC-54A5-40BF-9B33-DD2C3C756DA7', 
         'Initial load (57 total rows, file 1 of 1) for table TValLookUp',
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
-- #Rows Exported: 57
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
