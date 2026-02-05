 
-----------------------------------------------------------------------------
-- Table: FactFind.TImageTypeToOutputType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'D2C53478-6369-42AB-8738-7A4E38359222'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TImageTypeToOutputType ON; 
 
        INSERT INTO TImageTypeToOutputType([ImageTypeToOutputTypeId], [FinancialPlanningImageTypeId], [FinancialPlanningOutputTypeId], [ConcurrencyId])
        SELECT 1,1,1,1 UNION ALL 
        SELECT 2,2,1,1 UNION ALL 
        SELECT 3,3,1,1 UNION ALL 
        SELECT 4,4,1,1 UNION ALL 
        SELECT 5,5,2,1 UNION ALL 
        SELECT 6,9,3,1 UNION ALL 
        SELECT 7,10,3,1 UNION ALL 
        SELECT 8,11,3,1 UNION ALL 
        SELECT 9,12,3,1 UNION ALL 
        SELECT 10,13,4,1 UNION ALL 
        SELECT 11,14,4,1 UNION ALL 
        SELECT 12,15,4,1 UNION ALL 
        SELECT 13,16,4,1 UNION ALL 
        SELECT 14,17,4,1 UNION ALL 
        SELECT 15,18,4,1 UNION ALL 
        SELECT 16,19,5,1 UNION ALL 
        SELECT 17,20,5,1 UNION ALL 
        SELECT 18,21,5,1 UNION ALL 
        SELECT 19,22,5,1 UNION ALL 
        SELECT 20,23,5,1 UNION ALL 
        SELECT 21,24,6,1 UNION ALL 
        SELECT 22,25,6,1 UNION ALL 
        SELECT 23,26,6,1 UNION ALL 
        SELECT 24,7,7,1 UNION ALL 
        SELECT 25,8,7,1 UNION ALL 
        SELECT 26,6,2,1 UNION ALL 
        SELECT 27,1,8,1 UNION ALL 
        SELECT 28,2,8,1 UNION ALL 
        SELECT 29,3,8,1 UNION ALL 
        SELECT 30,4,8,1 UNION ALL 
        SELECT 31,27,4,1 UNION ALL 
        SELECT 32,28,3,1 UNION ALL 
        SELECT 33,29,4,1 UNION ALL 
        SELECT 34,30,9,1 UNION ALL 
        SELECT 35,31,10,1 
 
        SET IDENTITY_INSERT TImageTypeToOutputType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'D2C53478-6369-42AB-8738-7A4E38359222', 
         'Initial load (35 total rows, file 1 of 1) for table TImageTypeToOutputType',
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
-- #Rows Exported: 35
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
