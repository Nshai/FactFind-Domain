 
-----------------------------------------------------------------------------
-- Table: CRM.TCalculator
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'C6BEF36E-32FD-4911-8CE5-1C9D27E85DB0'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TCalculator ON; 
 
        INSERT INTO TCalculator([CalculatorId], [Identifier], [Definition], [ConcurrencyId])
        SELECT 1, 'Life Cover Shortfall', '/researchtools/calculator/definition/shortfall.xml',1 UNION ALL 
        SELECT 2, 'Investment Projection', '/researchtools/calculator/definition/InvestmentProjection.xml',1 UNION ALL 
        SELECT 3, 'Investment Targets', '/researchtools/calculator/definition/InvestmentTargets.xml',1 UNION ALL 
        SELECT 4, 'Mortgage Payment', NULL,1 
 
        SET IDENTITY_INSERT TCalculator OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'C6BEF36E-32FD-4911-8CE5-1C9D27E85DB0', 
         'Initial load (4 total rows, file 1 of 1) for table TCalculator',
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
