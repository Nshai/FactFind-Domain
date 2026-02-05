 
-----------------------------------------------------------------------------
-- Table: FactFind.TAtrRefAccessOption
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '7FB3D0B0-0C3A-41F1-B666-4AD17B842FB6'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TAtrRefAccessOption ON; 
 
        INSERT INTO TAtrRefAccessOption([AtrRefAccessOptionId], [Identifier], [ConcurrencyId])
        SELECT 4, 'Adviser and Client Portal',1 UNION ALL 
        SELECT 3, 'Client Portal',1 UNION ALL 
        SELECT 2, 'Adviser Only',1 UNION ALL 
        SELECT 1, 'Nobody',1 
 
        SET IDENTITY_INSERT TAtrRefAccessOption OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '7FB3D0B0-0C3A-41F1-B666-4AD17B842FB6', 
         'Initial load (4 total rows, file 1 of 1) for table TAtrRefAccessOption',
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
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
