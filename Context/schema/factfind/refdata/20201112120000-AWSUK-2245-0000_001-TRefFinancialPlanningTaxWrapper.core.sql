 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefFinancialPlanningTaxWrapper
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '2F844EEE-79FA-4993-83AA-AE6E9EDA59C4'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefFinancialPlanningTaxWrapper ON; 
 
        INSERT INTO TRefFinancialPlanningTaxWrapper([RefFinancialPlanningTaxWrapperId], [Description], [IsPension], [ConcurrencyId])
        SELECT 2, 'Insurance Fund',0,1 UNION ALL 
        SELECT 3, 'Investment Trust',0,1 UNION ALL 
        SELECT 4, 'ISA (Cash)',0,1 UNION ALL 
        SELECT 5, 'ISA (Stocks & Shares)',0,1 UNION ALL 
        SELECT 6, 'OEIC / Unit Trust',0,1 UNION ALL 
        SELECT 8, 'Pension',1,1 UNION ALL 
        SELECT 9, 'SIPP',0,1 UNION ALL 
        SELECT 10, 'Offshore Bond',0,1 UNION ALL 
        SELECT 11, 'Offshore Fund',0,1 UNION ALL 
        SELECT 12, 'OEIC / Unit Trust / Insurance Fund',0,1 
 
        SET IDENTITY_INSERT TRefFinancialPlanningTaxWrapper OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '2F844EEE-79FA-4993-83AA-AE6E9EDA59C4', 
         'Initial load (10 total rows, file 1 of 1) for table TRefFinancialPlanningTaxWrapper',
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
