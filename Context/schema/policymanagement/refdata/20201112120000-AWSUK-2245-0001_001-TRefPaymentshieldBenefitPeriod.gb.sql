 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefPaymentshieldBenefitPeriod
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '0E269508-1A48-4766-9CB6-82B8F725153A'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPaymentshieldBenefitPeriod ON; 
 
        INSERT INTO TRefPaymentshieldBenefitPeriod([RefPaymentshieldBenefitPeriodId], [Name], [ConcurrencyId])
        SELECT 1, 'TwelveMonths',1 UNION ALL 
        SELECT 2, 'TwentyFourMonths',1 
 
        SET IDENTITY_INSERT TRefPaymentshieldBenefitPeriod OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '0E269508-1A48-4766-9CB6-82B8F725153A', 
         'Initial load (2 total rows, file 1 of 1) for table TRefPaymentshieldBenefitPeriod',
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
-- #Rows Exported: 2
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
