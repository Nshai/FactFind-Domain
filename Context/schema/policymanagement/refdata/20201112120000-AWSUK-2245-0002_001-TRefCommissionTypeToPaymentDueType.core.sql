 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefCommissionTypeToPaymentDueType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '173E4A08-70D9-422A-9764-38E64FE31339'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefCommissionTypeToPaymentDueType ON; 
 
        INSERT INTO TRefCommissionTypeToPaymentDueType([RefCommissionTypeToPaymentDueTypeId], [RefCommissionTypeId], [RefPaymentDueTypeId], [ConcurrencyId])
        SELECT 1,1,1,1 UNION ALL 
        SELECT 2,2,1,1 UNION ALL 
        SELECT 3,3,1,1 UNION ALL 
        SELECT 4,4,1,1 UNION ALL 
        SELECT 5,5,1,1 UNION ALL 
        SELECT 6,6,1,1 UNION ALL 
        SELECT 7,1,2,1 UNION ALL 
        SELECT 8,2,2,1 UNION ALL 
        SELECT 9,3,2,1 UNION ALL 
        SELECT 10,4,2,1 UNION ALL 
        SELECT 11,5,2,1 UNION ALL 
        SELECT 12,6,2,1 UNION ALL 
        SELECT 13,1,3,1 UNION ALL 
        SELECT 14,2,3,1 UNION ALL 
        SELECT 15,3,3,1 UNION ALL 
        SELECT 16,4,3,1 UNION ALL 
        SELECT 17,5,3,1 UNION ALL 
        SELECT 18,6,3,1 UNION ALL 
        SELECT 19,1,4,1 UNION ALL 
        SELECT 20,2,4,1 UNION ALL 
        SELECT 21,3,4,1 UNION ALL 
        SELECT 22,4,4,1 UNION ALL 
        SELECT 23,5,4,1 UNION ALL 
        SELECT 24,6,4,1 UNION ALL 
        SELECT 25,7,5,1 UNION ALL 
        SELECT 26,7,6,1 UNION ALL 
        SELECT 27,7,7,1 UNION ALL 
        SELECT 28,7,8,1 
 
        SET IDENTITY_INSERT TRefCommissionTypeToPaymentDueType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '173E4A08-70D9-422A-9764-38E64FE31339', 
         'Initial load (28 total rows, file 1 of 1) for table TRefCommissionTypeToPaymentDueType',
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
-- #Rows Exported: 28
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
