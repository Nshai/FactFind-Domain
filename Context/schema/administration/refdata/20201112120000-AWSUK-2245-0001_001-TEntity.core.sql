 
-----------------------------------------------------------------------------
-- Table: Administration.TEntity
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'D95B273B-DBAE-44FC-BD9F-2EC242A89B2E'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TEntity ON; 
 
        INSERT INTO TEntity([EntityId], [Identifier], [Descriptor], [Db], [ConcurrencyId])
        SELECT 8, 'Account', 'Account', 'CRM',1 UNION ALL 
        SELECT 5, 'Practitioner', 'Practitioner', 'CRM',1 UNION ALL 
        SELECT 7, 'Lead', 'Lead', 'CRM',1 UNION ALL 
        SELECT 2, 'CRMContact', 'CRMContact', 'CRM',1 
 
        SET IDENTITY_INSERT TEntity OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'D95B273B-DBAE-44FC-BD9F-2EC242A89B2E', 
         'Initial load (4 total rows, file 1 of 1) for table TEntity',
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
