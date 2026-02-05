 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TIntegratedSystemDocumentMapping
--    Join: join TApplicationLink l on l.ApplicationLinkId = TIntegratedSystemDocumentMapping.ApplicationLinkId
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '629DF708-764B-4A26-B39E-0CCA1F38B55E'
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
        SET IDENTITY_INSERT TIntegratedSystemDocumentMapping ON; 
 
        INSERT INTO TIntegratedSystemDocumentMapping([IntegratedSystemDocumentMappingId], [ApplicationLinkId], [IsSaveDocuments], [DocumentCategoryId], [DocumentSubCategoryId], [ConcurrencyId])
        SELECT 903,48852,1,NULL,NULL,1 
 
        SET IDENTITY_INSERT TIntegratedSystemDocumentMapping OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '629DF708-764B-4A26-B39E-0CCA1F38B55E', 
         'Initial load (1 total rows, file 1 of 1) for table TIntegratedSystemDocumentMapping',
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
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
