 
-----------------------------------------------------------------------------
-- Table: FactFind.TFinancialPlanningOutputType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'D4FE5012-0902-46B0-A723-791248CB6200'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TFinancialPlanningOutputType ON; 
 
        INSERT INTO TFinancialPlanningOutputType([FinancialPlanningOutputTypeId], [Name], [ToolName], [ConcurrencyId], [OutputIdentifier])
        SELECT 1, 'Risk Summary', 'Risk Profiler',1, 'QTRisk_Template' UNION ALL 
        SELECT 2, 'Investment Summary', 'Investment Planner',1, 'QTInvestmentA_Template' UNION ALL 
        SELECT 3, 'Current Portfolio Summary', 'Portfolio Analyser',1, 'PortfolioAnalysisAViewPortfolioReport' UNION ALL 
        SELECT 4, 'Portfolio Solution', 'Portfolio Analyser',1, 'PortfolioAnalysisAReport' UNION ALL 
        SELECT 5, 'Lifetime Planner Summary', 'Lifetime Planner',1, 'CashflowAnalysisAReport' UNION ALL 
        SELECT 6, 'What If', 'Lifetime Planner',1, 'CashflowAnalysisAComparisonReport' UNION ALL 
        SELECT 7, 'Retirement Summary', 'Retirement Planner',1, 'QTRetirementA_Template' UNION ALL 
        SELECT 8, 'Risk Summary', 'Risk Profiler',1, 'QTRisk_Template_Light' UNION ALL 
        SELECT 9, 'Protection Summary', 'Protection Planner',1, 'ProtectionA_Template' UNION ALL 
        SELECT 10, 'Pension Freedom Summary', 'Pension Freedom Planner',1, 'CashflowAnalysisPFPReport' 
 
        SET IDENTITY_INSERT TFinancialPlanningOutputType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'D4FE5012-0902-46B0-A723-791248CB6200', 
         'Initial load (10 total rows, file 1 of 1) for table TFinancialPlanningOutputType',
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
-- #Rows Exported: 10
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
