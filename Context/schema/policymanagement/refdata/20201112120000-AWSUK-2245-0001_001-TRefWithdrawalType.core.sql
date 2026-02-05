 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefWithdrawalType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'B9E8E36A-F85A-4E8B-9D58-C459B2B3A77F'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefWithdrawalType ON; 
 
        INSERT INTO TRefWithdrawalType([RefWithdrawalTypeId], [WithdrawalName], [RetireFg], [Extensible], [ConcurrencyId])
        SELECT 5, 'Transfer',0, NULL,1 UNION ALL 
        SELECT 4, '% Of Fund',0, NULL,2 UNION ALL 
        SELECT 3, '% Of Investment',0, NULL,2 UNION ALL 
        SELECT 2, 'Lump Sum',0, NULL,1 UNION ALL 
        SELECT 1, 'Regular',0, NULL,1 
 
        SET IDENTITY_INSERT TRefWithdrawalType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'B9E8E36A-F85A-4E8B-9D58-C459B2B3A77F', 
         'Initial load (5 total rows, file 1 of 1) for table TRefWithdrawalType',
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
-- #Rows Exported: 5
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
