 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefPaymentEventType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'EEB82185-ED0E-4D94-BB63-7EE9991E7530'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPaymentEventType ON; 
 
        INSERT INTO TRefPaymentEventType([RefPaymentEventTypeId], [PaymentEventTypeName], [RetireFg], [Extensible], [ConcurrencyId])
        SELECT 3, 'Both',NULL,NULL,1 UNION ALL 
        SELECT 2, '2nd Death',NULL,NULL,1 UNION ALL 
        SELECT 1, '1st Death',NULL,NULL,1 
 
        SET IDENTITY_INSERT TRefPaymentEventType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'EEB82185-ED0E-4D94-BB63-7EE9991E7530', 
         'Initial load (3 total rows, file 1 of 1) for table TRefPaymentEventType',
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
-- #Rows Exported: 3
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
