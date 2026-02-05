 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefApplicationCustomHandler
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '41BDCEC5-EAB2-4AA0-A290-261E67185B8F'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefApplicationCustomHandler ON; 
 
        INSERT INTO TRefApplicationCustomHandler([RefApplicationCustomHandlerId], [RefApplicationId], [HandlerPath], [IsArchived], [ConcurrencyId], [IntegratedSystemConfigRole])
        SELECT 1,10, '/nio/MortgageApplication/ApplicationPreview',0,1,2 UNION ALL 
        SELECT 2,35, '/nio/MortgageApplication/ApplicationPreview',0,1,2 UNION ALL 
        SELECT 4,10201, '/nio/MortgageApplication/ApplicationPreview',0,1,2 
 
        SET IDENTITY_INSERT TRefApplicationCustomHandler OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '41BDCEC5-EAB2-4AA0-A290-261E67185B8F', 
         'Initial load (3 total rows, file 1 of 1) for table TRefApplicationCustomHandler',
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
-- #Rows Exported: 3
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
