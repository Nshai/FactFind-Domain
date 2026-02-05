 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefDeductionsType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'A9DED3A5-8B31-487D-8731-43D6BE356707'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefDeductionsType ON; 
 
        INSERT INTO TRefDeductionsType([RefDeductionsTypeId], [Name])
        SELECT 1, 'None' UNION ALL 
        SELECT 2, 'Less State Benefits Actually Received (integrated)' UNION ALL 
        SELECT 3, 'Less Basic ESA' UNION ALL 
        SELECT 4, 'Less Basic ESA & WRAC' UNION ALL 
        SELECT 5, 'Less Basic ESA & Support Component' 
 
        SET IDENTITY_INSERT TRefDeductionsType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'A9DED3A5-8B31-487D-8731-43D6BE356707', 
         'Initial load (5 total rows, file 1 of 1) for table TRefDeductionsType',
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
-- #Rows Exported: 5
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
