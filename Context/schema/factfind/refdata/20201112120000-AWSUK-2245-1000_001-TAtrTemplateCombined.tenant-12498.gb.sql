 
-----------------------------------------------------------------------------
-- Table: FactFind.TAtrTemplateCombined
--    Join: join TAtrTemplate t on t.Guid = TAtrTemplateCombined.Guid
--   Where: WHERE t.IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '14B4DE6B-314F-4BE9-A866-6A2B3E139C05'
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
 
        INSERT INTO TAtrTemplateCombined([Guid], [AtrTemplateId], [Identifier], [Descriptor], [Active], [HasModels], [BaseAtrTemplate], [AtrRefPortfolioTypeId], [IndigoClientId], [IndigoClientGuid], [IsArchived], [ConcurrencyId], [msrepl_tran_version], [HasFreeTextAnswers])
        SELECT '5BE5917B-DFA6-4850-95CB-361AC27E2325',9140, 'Tillinghast 5', NULL,1,0,'C029D6F7-D7C7-4C61-9A98-DA62945FE6C1',NULL,12498,'14015FB2-5EDC-497E-ACD7-91925877F8DC',0,1,'9E7057DB-3598-47EC-9CD7-A10675A3DFA0',0 
 
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '14B4DE6B-314F-4BE9-A866-6A2B3E139C05', 
         'Initial load (1 total rows, file 1 of 1) for table TAtrTemplateCombined',
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
