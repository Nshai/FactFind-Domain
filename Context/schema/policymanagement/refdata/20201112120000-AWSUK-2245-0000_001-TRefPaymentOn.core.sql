 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefPaymentOn
--    Join: 
--   Where: WHERE IndigoClientId IS NULL
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '009C9A15-C6F0-4661-BBF7-7F17C2872453'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPaymentOn ON; 
 
        INSERT INTO TRefPaymentOn([RefPaymentOnId], [Descriptor], [ArchiveFG], [IndigoClientId], [ConcurrencyId])
        SELECT 1, 'On Death',1,NULL,1 UNION ALL 
        SELECT 2, 'Ill Health',1,NULL,1 
 
        SET IDENTITY_INSERT TRefPaymentOn OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '009C9A15-C6F0-4661-BBF7-7F17C2872453', 
         'Initial load (2 total rows, file 1 of 1) for table TRefPaymentOn',
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
