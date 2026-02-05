 
-----------------------------------------------------------------------------
-- Table: FactFind.TFinancialPlanningImageType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '69E5B17A-B7F3-4B83-906E-7508E12000C9'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TFinancialPlanningImageType ON; 
 
        INSERT INTO TFinancialPlanningImageType([FinancialPlanningImageTypeId], [ImageTypeName], [ImageTypeDisplayName], [ConcurrencyId])
        SELECT 1, 'questPieImageWithKey', 'Typical Asset Allocation For Risk Result',1 UNION ALL 
        SELECT 2, 'riskPieImageWithKey', 'Typical Asset Allocation For Selected Risk',1 UNION ALL 
        SELECT 3, 'riskQuestionnaire_1', 'Risk Questionnaire Result',1 UNION ALL 
        SELECT 4, 'summary_questionnaire', 'Selected Risk Profile',1 UNION ALL 
        SELECT 5, 'invLineGraphWithKey', 'Investment Forecast',1 UNION ALL 
        SELECT 6, 'invPieImageWithKey', 'Typical Asset Allocation',1 UNION ALL 
        SELECT 7, 'retPodGraphWithKey', 'Retirement Forecast',1 UNION ALL 
        SELECT 8, 'retPieImageWithKey', 'Typical Asset Allocation',1 UNION ALL 
        SELECT 9, 'futurePerformanceGraphWithKey', 'Future Performance V Target Risk Of Current Portfolio',1 UNION ALL 
        SELECT 10, 'pastPerformanceImg', 'Past Performance Of Current Portfolio',1 UNION ALL 
        SELECT 11, 'pie_reportWithKey', 'Asset Class Breakdown Of Current Portfolio',1 UNION ALL 
        SELECT 12, 'volatilityChartWithKey', 'Efficient Frontier',1 UNION ALL 
        SELECT 13, 'currentVoptimisedGraphWithKey', 'Analysed Portfolio V Selected Portfolio',1 UNION ALL 
        SELECT 14, 'viewPortfolio_pastPerformanceImg', 'Past Performance Of Analysed Portfolio',1 UNION ALL 
        SELECT 15, 'pie_reportWithKey', 'Asset Class Breakdown Of Analysed Portfolio',1 UNION ALL 
        SELECT 16, 'viewPortfolio_futurePerformanceGraphWithKey', 'Future Performance V Target Risk Of Analysed Portfolio',1 UNION ALL 
        SELECT 17, 'pastPerformanceImg', 'Past Performance Analysed V Selected Portfolio',1 UNION ALL 
        SELECT 18, 'volatilityChartWithKey', 'Efficient Frontier Analysed V Selected Portfolio',1 UNION ALL 
        SELECT 19, 'combinedChartWithKey', 'Current Wealth Analysis',1 UNION ALL 
        SELECT 20, 'debtchartWithKey', 'Debt Forecast',1 UNION ALL 
        SELECT 21, 'expenseschartWithKey', 'Expense Forecast',1 UNION ALL 
        SELECT 22, 'incomeschartWithKey', 'Income Forecast',1 UNION ALL 
        SELECT 23, 'wealthchartWithKey', 'Asset Forecast',1 UNION ALL 
        SELECT 24, 'overlaychartWithKey', 'Current V Revised Wealth Analysis',1 UNION ALL 
        SELECT 25, 'sideBySideChartCurrentCombinedWithKey', 'Current Wealth Analysis',1 UNION ALL 
        SELECT 26, 'sideBySideChartRevisedCombinedWithKey', 'Revised Wealth Analysis',1 UNION ALL 
        SELECT 27, 'existingVsConsolidatedAssets', 'Existing V Consolidated Asset Classes',1 UNION ALL 
        SELECT 28, 'currentLineGraphWithKey', 'Future Performance Growth V Target Risk Of Current Portfolio',1 UNION ALL 
        SELECT 29, 'viewPortfolio_volatilityChartWithKey', 'Efficient Frontier Selected Risk V Current Portfolio',1 UNION ALL 
        SELECT 30, 'lifeChart', 'Protection Planner LifeChart image',1 UNION ALL 
        SELECT 31, 'retirementincomechart', 'Pension Freedom Planner Retirement Income image',1 
 
        SET IDENTITY_INSERT TFinancialPlanningImageType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '69E5B17A-B7F3-4B83-906E-7508E12000C9', 
         'Initial load (31 total rows, file 1 of 1) for table TFinancialPlanningImageType',
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
-- #Rows Exported: 31
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
