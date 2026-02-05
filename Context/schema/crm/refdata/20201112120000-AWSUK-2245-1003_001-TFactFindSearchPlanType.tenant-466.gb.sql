 
-----------------------------------------------------------------------------
-- Table: CRM.TFactFindSearchPlanType
--    Join: JOIN TFactFindSearch s on s.FactFindSearchId = TFactFindSearchPlanType.FactFindSearchId
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'A6EF638F-A9C6-48FC-8BF4-2A0B787F330E'
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
        SET IDENTITY_INSERT TFactFindSearchPlanType ON; 
 
        INSERT INTO TFactFindSearchPlanType([FactFindSearchPlanTypeId], [FactFindSearchId], [RefPlanTypeId], [ConcurrencyId])
        SELECT 23186,951,25,1 UNION ALL 
        SELECT 23187,951,26,1 UNION ALL 
        SELECT 23188,951,27,1 UNION ALL 
        SELECT 23189,951,28,1 UNION ALL 
        SELECT 23190,951,29,1 UNION ALL 
        SELECT 23191,951,30,1 UNION ALL 
        SELECT 23192,951,31,1 UNION ALL 
        SELECT 23193,951,32,1 UNION ALL 
        SELECT 23194,951,33,1 UNION ALL 
        SELECT 23195,951,34,1 UNION ALL 
        SELECT 23196,951,35,1 UNION ALL 
        SELECT 23197,951,36,1 UNION ALL 
        SELECT 23198,951,38,1 UNION ALL 
        SELECT 23199,951,39,1 UNION ALL 
        SELECT 23200,951,40,1 UNION ALL 
        SELECT 23201,951,41,1 UNION ALL 
        SELECT 23202,951,42,1 UNION ALL 
        SELECT 23203,951,43,1 UNION ALL 
        SELECT 23204,951,44,1 UNION ALL 
        SELECT 23205,951,46,1 UNION ALL 
        SELECT 23206,951,47,1 UNION ALL 
        SELECT 23207,951,48,1 UNION ALL 
        SELECT 23208,951,49,1 UNION ALL 
        SELECT 23209,951,53,1 UNION ALL 
        SELECT 23210,951,56,1 UNION ALL 
        SELECT 23211,951,57,1 UNION ALL 
        SELECT 23212,951,62,1 UNION ALL 
        SELECT 23213,951,75,1 UNION ALL 
        SELECT 23214,951,79,1 UNION ALL 
        SELECT 23215,951,81,1 UNION ALL 
        SELECT 23216,951,82,1 UNION ALL 
        SELECT 23217,952,19,1 UNION ALL 
        SELECT 23218,952,50,1 UNION ALL 
        SELECT 23219,952,51,1 UNION ALL 
        SELECT 23220,952,52,1 UNION ALL 
        SELECT 23221,952,54,1 UNION ALL 
        SELECT 23222,952,55,1 UNION ALL 
        SELECT 23223,952,58,1 UNION ALL 
        SELECT 23224,952,59,1 UNION ALL 
        SELECT 23225,952,60,1 UNION ALL 
        SELECT 23226,952,61,1 UNION ALL 
        SELECT 23227,952,74,1 UNION ALL 
        SELECT 23228,953,1,1 UNION ALL 
        SELECT 23229,953,2,1 UNION ALL 
        SELECT 23230,953,3,1 UNION ALL 
        SELECT 23231,953,4,1 UNION ALL 
        SELECT 23232,953,5,1 UNION ALL 
        SELECT 23233,953,6,1 UNION ALL 
        SELECT 23234,953,7,1 UNION ALL 
        SELECT 23235,953,8,1 UNION ALL 
        SELECT 23236,953,9,1 UNION ALL 
        SELECT 23237,953,10,1 UNION ALL 
        SELECT 23238,953,11,1 UNION ALL 
        SELECT 23239,953,12,1 UNION ALL 
        SELECT 23240,953,13,1 UNION ALL 
        SELECT 23241,953,14,1 UNION ALL 
        SELECT 23242,953,15,1 UNION ALL 
        SELECT 23243,953,16,1 UNION ALL 
        SELECT 23244,953,17,1 UNION ALL 
        SELECT 23245,953,18,1 UNION ALL 
        SELECT 23246,953,20,1 UNION ALL 
        SELECT 23247,953,21,1 UNION ALL 
        SELECT 23248,953,22,1 UNION ALL 
        SELECT 23249,953,23,1 UNION ALL 
        SELECT 23250,953,24,1 UNION ALL 
        SELECT 23251,953,71,1 UNION ALL 
        SELECT 23252,953,72,1 
 
        SET IDENTITY_INSERT TFactFindSearchPlanType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'A6EF638F-A9C6-48FC-8BF4-2A0B787F330E', 
         'Initial load (67 total rows, file 1 of 1) for table TFactFindSearchPlanType',
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
-- #Rows Exported: 67
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
