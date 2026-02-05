 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefFundTransactionType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '0A49B92E-07D7-40D0-9362-5E3E74921E55'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefFundTransactionType ON; 
 
        INSERT INTO TRefFundTransactionType([RefFundTransactionTypeId], [Description], [ConcurrencyId])
        SELECT 1, 'Purchase',1 UNION ALL 
        SELECT 2, 'Sale',1 UNION ALL 
        SELECT 3, 'Security Transfer In',1 UNION ALL 
        SELECT 4, 'Security Transfer Out',1 UNION ALL 
        SELECT 5, 'Switch Purchase',1 UNION ALL 
        SELECT 6, 'Switch Sale',1 UNION ALL 
        SELECT 7, 'Cancellation',1 UNION ALL 
        SELECT 8, 'Corporate Event Stock +',1 UNION ALL 
        SELECT 9, 'Corporate Event Stock -',1 UNION ALL 
        SELECT 10, 'Transfer In Cash',1 UNION ALL 
        SELECT 11, 'Transfer In (In Species/Stock)',1 UNION ALL 
        SELECT 12, 'Withdrawal',1 UNION ALL 
        SELECT 13, 'Income Reinvested',1 UNION ALL 
        SELECT 14, 'Accrued Bonus',1 UNION ALL 
        SELECT 15, 'Income Distributed',1 UNION ALL 
        SELECT 16, 'Charge',1 UNION ALL 
        SELECT 17, 'Bonus',1 UNION ALL 
        SELECT 18, 'Current',1 UNION ALL 
        SELECT 19, 'Transfer out Cash',1 UNION ALL 
        SELECT 20, 'Transfer out (In Species/Stock)',1 UNION ALL 
        SELECT 21, 'Re-registration Out',1 UNION ALL 
        SELECT 22, 'Re-registration In',1 UNION ALL 
        SELECT 23, 'Reattribution',1 UNION ALL 
        SELECT 24, 'Fund Split',1 UNION ALL 
        SELECT 25, 'Fund Amalgamation',1 UNION ALL 
        SELECT 26, 'Tax Credit',1 UNION ALL 
        SELECT 27, 'Share Buy Back',1 UNION ALL 
        SELECT 28, 'Adjustment',1 UNION ALL 
        SELECT 29, 'Cash Receipt',1 UNION ALL 
        SELECT 30, 'Cash Withdrawal',1 UNION ALL 
        SELECT 31, 'Conversion',1 UNION ALL 
        SELECT 32, 'Dividend',1 UNION ALL 
        SELECT 33, 'Fees & Charges',1 UNION ALL 
        SELECT 34, 'Interest',1 UNION ALL 
        SELECT 35, 'Partial Surrender',1 UNION ALL 
        SELECT 36, 'Rebate',1 
 
        SET IDENTITY_INSERT TRefFundTransactionType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '0A49B92E-07D7-40D0-9362-5E3E74921E55', 
         'Initial load (36 total rows, file 1 of 1) for table TRefFundTransactionType',
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
-- #Rows Exported: 36
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
