 
-----------------------------------------------------------------------------
-- Table: FactFind.TAtrTemplate
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'DDDD3193-25A7-4B71-8563-671B2D8BF9E7'
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
        SET IDENTITY_INSERT TAtrTemplate ON; 
 
        INSERT INTO TAtrTemplate([AtrTemplateId], [Identifier], [Descriptor], [Active], [HasModels], [BaseAtrTemplate], [AtrRefPortfolioTypeId], [IndigoClientId], [Guid], [IsArchived], [ConcurrencyId], [HasFreeTextAnswers])
        SELECT 9140, 'Tillinghast 5', NULL,1,0,'C029D6F7-D7C7-4C61-9A98-DA62945FE6C1',NULL,12498,'5BE5917B-DFA6-4850-95CB-361AC27E2325',0,1,0 
 
        SET IDENTITY_INSERT TAtrTemplate OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'DDDD3193-25A7-4B71-8563-671B2D8BF9E7', 
         'Initial load (1 total rows, file 1 of 1) for table TAtrTemplate',
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
-- #Rows Exported: 1
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
