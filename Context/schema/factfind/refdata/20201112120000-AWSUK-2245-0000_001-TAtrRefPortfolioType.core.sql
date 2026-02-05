 
-----------------------------------------------------------------------------
-- Table: FactFind.TAtrRefPortfolioType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '417A37A8-6D60-486C-906C-65B7D69CD236'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TAtrRefPortfolioType ON; 
 
        INSERT INTO TAtrRefPortfolioType([AtrRefPortfolioTypeId], [Identifier], [Custom], [IsModelPortfolios], [ConcurrencyId])
        SELECT 5, 'Extended Asset Classes',0,1,1 UNION ALL 
        SELECT 4, 'Custom Asset Classes',1,0,1 UNION ALL 
        SELECT 3, 'IMA Sectors',0,0,1 UNION ALL 
        SELECT 2, 'Grouped Sectors',0,1,1 UNION ALL 
        SELECT 1, 'Primary Asset Classes',0,0,1 
 
        SET IDENTITY_INSERT TAtrRefPortfolioType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '417A37A8-6D60-486C-906C-65B7D69CD236', 
         'Initial load (5 total rows, file 1 of 1) for table TAtrRefPortfolioType',
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
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
