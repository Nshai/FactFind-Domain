 
-----------------------------------------------------------------------------
-- Table: CRM.TRefCategoryAM
--    Join: 
--   Where: WHERE IndClientId=12498
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '02DE510E-7084-48BC-967E-5B0888E0D0C8'
     AND TenantId = 12498
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefCategoryAM ON; 
 
        INSERT INTO TRefCategoryAM([RefCategoryAMId], [Description], [ArchiveFG], [IndClientId], [Extensible], [ConcurrencyId])
        SELECT 13398, 'Business',0,12498,NULL,1 UNION ALL 
        SELECT 13399, 'Personal',0,12498,NULL,1 UNION ALL 
        SELECT 13400, 'Party',0,12498,NULL,1 UNION ALL 
        SELECT 13401, 'Team Building',0,12498,NULL,1 
 
        SET IDENTITY_INSERT TRefCategoryAM OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '02DE510E-7084-48BC-967E-5B0888E0D0C8', 
         'Initial load (4 total rows, file 1 of 1) for table TRefCategoryAM',
         12498, 
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
