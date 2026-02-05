 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefPortfolioCategory
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '552A9AB9-080B-4531-88B5-917B925DA3AD'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPortfolioCategory ON; 
 
        INSERT INTO TRefPortfolioCategory([RefPortfolioCategoryId], [PortfolioCategoryName], [PortfolioCategoryDisplayText])
        SELECT 1, 'Investment', 'Investment' UNION ALL 
        SELECT 2, 'Mortgage', 'Mortgage' UNION ALL 
        SELECT 3, 'Protection', 'Protection' UNION ALL 
        SELECT 4, 'Pension', 'Pension' UNION ALL 
        SELECT 5, 'Loan', 'Loan' UNION ALL 
        SELECT 6, 'Saving', 'Saving' UNION ALL 
        SELECT 7, 'CreditCard', 'Credit Card' UNION ALL 
        SELECT 8, 'CurrentAccount', 'Current Account' 
 
        SET IDENTITY_INSERT TRefPortfolioCategory OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '552A9AB9-080B-4531-88B5-917B925DA3AD', 
         'Initial load (8 total rows, file 1 of 1) for table TRefPortfolioCategory',
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
-- #Rows Exported: 8
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
