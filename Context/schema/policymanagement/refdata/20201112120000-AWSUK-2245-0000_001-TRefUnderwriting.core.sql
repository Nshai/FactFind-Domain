 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefUnderwriting
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'DEEA3B38-8B82-4E39-AF0F-B97A4870523F'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefUnderwriting ON; 
 
        INSERT INTO TRefUnderwriting([RefUnderwritingId], [Name])
        SELECT 1, 'Full Medical Underwriting' UNION ALL 
        SELECT 2, 'Moratorium' UNION ALL 
        SELECT 3, 'Medical History Disregarded' UNION ALL 
        SELECT 4, 'Continuous Personal Medical Exclusion' 
 
        SET IDENTITY_INSERT TRefUnderwriting OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'DEEA3B38-8B82-4E39-AF0F-B97A4870523F', 
         'Initial load (4 total rows, file 1 of 1) for table TRefUnderwriting',
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
-- #Rows Exported: 4
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
