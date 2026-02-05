 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefPaymentDueType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '6F065F0A-5C24-4BC0-8D05-7D7CE86DD0DC'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPaymentDueType ON; 
 
        INSERT INTO TRefPaymentDueType([RefPaymentDueTypeId], [PaymentDueType], [RefLicenseTypeId], [RetireFg], [Extensible], [ConcurrencyId])
        SELECT 1, 'At start of policy',1,0,NULL,1 UNION ALL 
        SELECT 2, 'specific date',1,0,NULL,1 UNION ALL 
        SELECT 3, 'Now',1,0,NULL,1 UNION ALL 
        SELECT 4, 'After Charging Period',1,0,NULL,1 UNION ALL 
        SELECT 5, 'On Offer',2,0,NULL,1 UNION ALL 
        SELECT 6, 'On Exchange',2,0,NULL,1 UNION ALL 
        SELECT 7, 'On Completion',2,0,NULL,1 UNION ALL 
        SELECT 8, 'On Pay Run After Completion',2,0,NULL,1 UNION ALL 
        SELECT 9, 'On Offer',4,0,NULL,1 UNION ALL 
        SELECT 10, 'On Exchange',4,0,NULL,1 UNION ALL 
        SELECT 11, 'On Completion',4,0,NULL,1 UNION ALL 
        SELECT 12, 'On Pay Run After Completion',4,0,NULL,1 UNION ALL 
        SELECT 13, 'At start of policy',5,0,NULL,1 UNION ALL 
        SELECT 14, 'specific date',5,0,NULL,1 UNION ALL 
        SELECT 15, 'Now',5,0,NULL,1 UNION ALL 
        SELECT 16, 'After Charging Period',5,0,NULL,1 UNION ALL 
        SELECT 17, 'At start of policy',12,0,NULL,1 UNION ALL 
        SELECT 18, 'specific date',12,0,NULL,1 UNION ALL 
        SELECT 19, 'Now',12,0,NULL,1 UNION ALL 
        SELECT 20, 'After Charging Period',12,0,NULL,1 
 
        SET IDENTITY_INSERT TRefPaymentDueType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '6F065F0A-5C24-4BC0-8D05-7D7CE86DD0DC', 
         'Initial load (20 total rows, file 1 of 1) for table TRefPaymentDueType',
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
-- #Rows Exported: 20
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
