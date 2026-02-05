 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefOptions
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'E27FC7E1-4E39-4007-8ABE-7869DA70655E'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefOptions ON; 
 
        INSERT INTO TRefOptions([RefOptionsId], [RefOptionsName], [RetireFg], [ConcurrencyId])
        SELECT 5, 'none',0,1 UNION ALL 
        SELECT 4, 'family income benefit',0,1 UNION ALL 
        SELECT 3, 'guaranteed insurability',0,1 UNION ALL 
        SELECT 2, 'convertible',0,1 UNION ALL 
        SELECT 1, 'renewable',0,1 
 
        SET IDENTITY_INSERT TRefOptions OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'E27FC7E1-4E39-4007-8ABE-7869DA70655E', 
         'Initial load (5 total rows, file 1 of 1) for table TRefOptions',
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
