 
-----------------------------------------------------------------------------
-- Table: FactFind.TAtrRefPortfolioTypeAssetClass
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'B3A59CA9-0ED8-405A-A10B-66439E79F7A0'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TAtrRefPortfolioTypeAssetClass ON; 
 
        INSERT INTO TAtrRefPortfolioTypeAssetClass([AtrRefPortfolioTypeAssetClassId], [AtrRefPortfolioTypeId], [AtrRefAssetClassId], [ConcurrencyId])
        SELECT 71,2,40,1 UNION ALL 
        SELECT 69,6,47,1 UNION ALL 
        SELECT 68,6,46,1 UNION ALL 
        SELECT 67,6,2,1 UNION ALL 
        SELECT 66,6,45,1 UNION ALL 
        SELECT 65,6,44,1 UNION ALL 
        SELECT 64,6,43,1 UNION ALL 
        SELECT 63,6,42,1 UNION ALL 
        SELECT 62,6,41,1 UNION ALL 
        SELECT 61,6,40,1 UNION ALL 
        SELECT 60,6,39,1 UNION ALL 
        SELECT 59,6,1,1 UNION ALL 
        SELECT 58,6,38,1 UNION ALL 
        SELECT 57,5,51,1 UNION ALL 
        SELECT 56,5,50,1 UNION ALL 
        SELECT 55,5,49,1 UNION ALL 
        SELECT 54,5,48,1 UNION ALL 
        SELECT 53,5,47,1 UNION ALL 
        SELECT 52,5,46,1 UNION ALL 
        SELECT 51,5,2,1 UNION ALL 
        SELECT 50,5,45,1 UNION ALL 
        SELECT 49,5,44,1 UNION ALL 
        SELECT 48,5,43,1 UNION ALL 
        SELECT 47,5,42,1 UNION ALL 
        SELECT 46,5,41,1 UNION ALL 
        SELECT 45,5,40,1 UNION ALL 
        SELECT 44,5,39,1 UNION ALL 
        SELECT 43,5,1,1 UNION ALL 
        SELECT 42,5,38,1 UNION ALL 
        SELECT 41,2,37,1 UNION ALL 
        SELECT 40,2,36,1 UNION ALL 
        SELECT 39,2,35,1 UNION ALL 
        SELECT 37,2,2,1 UNION ALL 
        SELECT 36,2,1,1 UNION ALL 
        SELECT 35,1,33,1 UNION ALL 
        SELECT 34,1,32,1 UNION ALL 
        SELECT 33,1,2,1 UNION ALL 
        SELECT 32,1,1,1 UNION ALL 
        SELECT 31,3,31,1 UNION ALL 
        SELECT 30,3,30,1 UNION ALL 
        SELECT 29,3,29,1 UNION ALL 
        SELECT 28,3,28,1 UNION ALL 
        SELECT 27,3,27,1 UNION ALL 
        SELECT 26,3,26,1 UNION ALL 
        SELECT 25,3,25,1 UNION ALL 
        SELECT 24,3,24,1 UNION ALL 
        SELECT 23,3,23,1 UNION ALL 
        SELECT 22,3,22,1 UNION ALL 
        SELECT 21,3,21,1 UNION ALL 
        SELECT 20,3,20,1 UNION ALL 
        SELECT 19,3,19,1 UNION ALL 
        SELECT 18,3,18,1 UNION ALL 
        SELECT 17,3,17,1 UNION ALL 
        SELECT 16,3,16,1 UNION ALL 
        SELECT 15,3,15,1 UNION ALL 
        SELECT 14,3,14,1 UNION ALL 
        SELECT 13,3,13,1 UNION ALL 
        SELECT 12,3,12,1 UNION ALL 
        SELECT 11,3,11,1 UNION ALL 
        SELECT 10,3,10,1 UNION ALL 
        SELECT 9,3,9,1 UNION ALL 
        SELECT 8,3,8,1 UNION ALL 
        SELECT 7,3,7,1 UNION ALL 
        SELECT 6,3,6,1 UNION ALL 
        SELECT 5,3,5,1 UNION ALL 
        SELECT 4,3,4,1 UNION ALL 
        SELECT 3,3,3,1 UNION ALL 
        SELECT 2,3,2,1 UNION ALL 
        SELECT 1,3,1,1 UNION ALL 
        SELECT 72,2,43,1 UNION ALL 
        SELECT 73,2,44,1 
 
        SET IDENTITY_INSERT TAtrRefPortfolioTypeAssetClass OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'B3A59CA9-0ED8-405A-A10B-66439E79F7A0', 
         'Initial load (71 total rows, file 1 of 1) for table TAtrRefPortfolioTypeAssetClass',
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
-- #Rows Exported: 71
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
