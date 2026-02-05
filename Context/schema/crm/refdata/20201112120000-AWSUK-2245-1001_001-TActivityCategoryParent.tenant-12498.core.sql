 
-----------------------------------------------------------------------------
-- Table: CRM.TActivityCategoryParent
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'B0A9DC83-4B47-489D-92B6-047B9F53BD09'
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
        SET IDENTITY_INSERT TActivityCategoryParent ON; 
 
        INSERT INTO TActivityCategoryParent([ActivityCategoryParentId], [Name], [IndigoClientId], [ConcurrencyId], [IsArchived])
        SELECT 27372, 'New Lead',12498,1,0 UNION ALL 
        SELECT 27373, 'New Client',12498,1,0 UNION ALL 
        SELECT 27382, 'Client Servicing',12498,1,0 UNION ALL 
        SELECT 27374, 'Advice Process',12498,1,0 UNION ALL 
        SELECT 27383, 'New Business Processing',12498,1,0 
 
        SET IDENTITY_INSERT TActivityCategoryParent OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'B0A9DC83-4B47-489D-92B6-047B9F53BD09', 
         'Initial load (5 total rows, file 1 of 1) for table TActivityCategoryParent',
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
-- #Rows Exported: 5
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
