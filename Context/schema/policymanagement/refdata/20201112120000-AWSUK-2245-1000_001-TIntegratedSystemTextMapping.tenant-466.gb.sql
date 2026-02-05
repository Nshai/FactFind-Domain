 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TIntegratedSystemTextMapping
--    Join: join TApplicationLink l on l.ApplicationLinkId = TIntegratedSystemTextMapping.ApplicationLinkId
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '975D57DF-CD15-4F55-8840-0E1BE131F531'
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
        SET IDENTITY_INSERT TIntegratedSystemTextMapping ON; 
 
        INSERT INTO TIntegratedSystemTextMapping([IntegratedSystemTextMappingId], [ApplicationLinkId], [DisplayAsReadOnly], [DeclarationText], [ConcurrencyId])
        SELECT 2128,27961,1, 'Apply directly to the Provider',1 UNION ALL 
        SELECT 317,8917,1, 'Apply via Mortgage Trading Exchange (MTE)',1 
 
        SET IDENTITY_INSERT TIntegratedSystemTextMapping OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '975D57DF-CD15-4F55-8840-0E1BE131F531', 
         'Initial load (2 total rows, file 1 of 1) for table TIntegratedSystemTextMapping',
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
-- #Rows Exported: 2
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
