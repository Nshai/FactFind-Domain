 
-----------------------------------------------------------------------------
-- Table: Administration.TIndigoClientExtended
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '15C050D3-F8E4-453E-84D1-43DC35B38B75'
     AND TenantId = 466
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TIndigoClientExtended ON; 
 
        INSERT INTO TIndigoClientExtended([IndigoClientExtendedId], [IndigoClientId], [FinancialYearStartMonth], [Website], [ConcurrencyId], [SftpUserName], [GcdContractFileFormat], [GcdPersonFileFormat], [FpfDocumentFileFormat], [LogEventsTo], [DocumentGeneratorVersion])
        SELECT 319,466,1, '',2, NULL, NULL, NULL, NULL, NULL,2 
 
        SET IDENTITY_INSERT TIndigoClientExtended OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '15C050D3-F8E4-453E-84D1-43DC35B38B75', 
         'Initial load (1 total rows, file 1 of 1) for table TIndigoClientExtended',
         466, 
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
-- #Rows Exported: 1
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
