 
-----------------------------------------------------------------------------
-- Table: FactFind.TAtrRefPortfolioTerm
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'FC8EFB30-565C-4A83-926E-5EE735148CA5'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TAtrRefPortfolioTerm ON; 
 
        INSERT INTO TAtrRefPortfolioTerm([AtrRefPortfolioTermId], [Term], [Identifier], [ConcurrencyId])
        SELECT 4,10, '10 Years',1 UNION ALL 
        SELECT 3,5, '5 Years',1 UNION ALL 
        SELECT 2,3, '3 Years',1 UNION ALL 
        SELECT 1,1, '1 Year',1 
 
        SET IDENTITY_INSERT TAtrRefPortfolioTerm OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'FC8EFB30-565C-4A83-926E-5EE735148CA5', 
         'Initial load (4 total rows, file 1 of 1) for table TAtrRefPortfolioTerm',
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
