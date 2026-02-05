 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefQuoteStatus
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '95E7374D-52AA-4D00-9033-A3EE7548603F'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefQuoteStatus ON; 
 
        INSERT INTO TRefQuoteStatus([RefQuoteStatusId], [QuoteStatusName], [ConcurrencyId])
        SELECT 1, 'In Process',1 UNION ALL 
        SELECT 2, 'Partial',1 UNION ALL 
        SELECT 3, 'Complete',1 UNION ALL 
        SELECT 4, 'Pending',1 UNION ALL 
        SELECT 5, 'Submitted to Broker',1 UNION ALL 
        SELECT 6, 'Broker Submission Failed',1 UNION ALL 
        SELECT 7, 'Polling for Results',1 UNION ALL 
        SELECT 8, 'Results Request Failed',1 UNION ALL 
        SELECT 9, 'Result Polling Timeout',1 UNION ALL 
        SELECT 10, 'No Quotes generated',1 UNION ALL 
        SELECT 11, 'Complete With Errors',1 UNION ALL 
        SELECT 12, 'Submitted to Portal',1 UNION ALL 
        SELECT 13, 'Incomplete',1 UNION ALL 
        SELECT 14, 'Portal Submission Failed',1 
 
        SET IDENTITY_INSERT TRefQuoteStatus OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '95E7374D-52AA-4D00-9033-A3EE7548603F', 
         'Initial load (14 total rows, file 1 of 1) for table TRefQuoteStatus',
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
-- #Rows Exported: 14
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
