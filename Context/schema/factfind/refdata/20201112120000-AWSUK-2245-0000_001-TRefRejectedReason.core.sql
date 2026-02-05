 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefRejectedReason
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'A7927FA3-4ABE-4795-8F46-CEBEABBD58C3'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefRejectedReason ON; 
 
        INSERT INTO TRefRejectedReason([RefRejectedReasonId], [Description], [ConcurrencyId])
        SELECT 1, 'Affordability',0 UNION ALL 
        SELECT 2, 'Change in client circumstances',0 UNION ALL 
        SELECT 3, 'Alternative option selected by client',0 UNION ALL 
        SELECT 4, 'Goal no longer valid',0 UNION ALL 
        SELECT 5, 'Advice not proceeded with',0 UNION ALL 
        SELECT 6, 'Other',0 UNION ALL 
        SELECT 7, 'Impaired Life',0 
 
        SET IDENTITY_INSERT TRefRejectedReason OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'A7927FA3-4ABE-4795-8F46-CEBEABBD58C3', 
         'Initial load (7 total rows, file 1 of 1) for table TRefRejectedReason',
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
-- #Rows Exported: 7
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
