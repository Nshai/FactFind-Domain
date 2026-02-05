 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefXSLType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '360FF7A2-1554-43A7-AA50-C5BF11CF3F8F'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefXSLType ON; 
 
        INSERT INTO TRefXSLType([RefXSLTypeId], [Identifier], [IsArchived], [ConcurrencyId])
        SELECT 1, 'Generate Quote Request',0,1 UNION ALL 
        SELECT 2, 'Process Quote Items',0,1 UNION ALL 
        SELECT 3, 'Generate Quote Summary',0,1 UNION ALL 
        SELECT 4, 'Generate Ts And Cs Request',0,1 UNION ALL 
        SELECT 5, 'View Document Selection',0,1 UNION ALL 
        SELECT 6, 'Generate Extranet Link Message',0,1 
 
        SET IDENTITY_INSERT TRefXSLType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '360FF7A2-1554-43A7-AA50-C5BF11CF3F8F', 
         'Initial load (6 total rows, file 1 of 1) for table TRefXSLType',
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
-- #Rows Exported: 6
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
