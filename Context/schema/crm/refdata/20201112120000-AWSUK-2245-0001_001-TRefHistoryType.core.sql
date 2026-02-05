 
-----------------------------------------------------------------------------
-- Table: CRM.TRefHistoryType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'BAE86209-C39D-4983-8C86-822AAD5DE1D5'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefHistoryType ON; 
 
        INSERT INTO TRefHistoryType([RefHistoryTypeId], [TypeName], [ArchiveFg], [Extensible], [ConcurrencyId])
        SELECT 4, 'All Types...',NULL,NULL,1 UNION ALL 
        SELECT 3, 'Events',NULL,NULL,1 UNION ALL 
        SELECT 2, 'Tasks',NULL,NULL,1 UNION ALL 
        SELECT 1, 'History Items',NULL,NULL,1 
 
        SET IDENTITY_INSERT TRefHistoryType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'BAE86209-C39D-4983-8C86-822AAD5DE1D5', 
         'Initial load (4 total rows, file 1 of 1) for table TRefHistoryType',
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
-- #Rows Exported: 4
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
