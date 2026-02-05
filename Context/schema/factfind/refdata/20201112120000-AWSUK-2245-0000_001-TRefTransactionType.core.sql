 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefTransactionType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '53929EFD-FA0E-4D67-8875-D5C6E2298779'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefTransactionType ON; 
 
        INSERT INTO TRefTransactionType([RefTransactionTypeId], [TransactionType], [ConcurrencyId])
        SELECT 1, 'Switch',0 UNION ALL 
        SELECT 2, 'Withdrawal',0 UNION ALL 
        SELECT 3, 'Withdrawal Decrease.',0 UNION ALL 
        SELECT 4, 'Withdrawal Increase.',0 UNION ALL 
        SELECT 5, 'Decrease Regular Cont.',0 UNION ALL 
        SELECT 6, 'Increase Regular Cont.',0 UNION ALL 
        SELECT 7, 'Top Up',0 UNION ALL 
        SELECT 8, 'New Plan',0 UNION ALL 
        SELECT 9, 'Encashment',0 UNION ALL 
        SELECT 12, 'Take no action',0 UNION ALL 
        SELECT 10, 'Deactivate Plan',0 
 
        SET IDENTITY_INSERT TRefTransactionType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '53929EFD-FA0E-4D67-8875-D5C6E2298779', 
         'Initial load (11 total rows, file 1 of 1) for table TRefTransactionType',
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
-- #Rows Exported: 11
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
