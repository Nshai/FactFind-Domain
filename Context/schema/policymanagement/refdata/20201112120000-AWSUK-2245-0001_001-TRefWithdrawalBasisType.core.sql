 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefWithdrawalBasisType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'AAF89C97-2C81-4DDC-AA0E-C30B204ED5DC'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefWithdrawalBasisType ON; 
 
        INSERT INTO TRefWithdrawalBasisType([RefWithdrawalBasisTypeId], [WithdrawalBasisName], [RetireFg], [ConcurrencyId])
        SELECT 3, 'Dividend only',0,1 UNION ALL 
        SELECT 2, '% of Fund',0,1 UNION ALL 
        SELECT 1, '% of Investment',0,1 
 
        SET IDENTITY_INSERT TRefWithdrawalBasisType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'AAF89C97-2C81-4DDC-AA0E-C30B204ED5DC', 
         'Initial load (3 total rows, file 1 of 1) for table TRefWithdrawalBasisType',
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
