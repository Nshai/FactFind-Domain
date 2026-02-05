 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefSchemeSetUp
--    Join: 
--   Where: WHERE IndigoClientId IS NULL
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'AF39E5D9-E6B2-4BFF-B54D-ABF08BDA03D3'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefSchemeSetUp ON; 
 
        INSERT INTO TRefSchemeSetUp([RefSchemeSetUpId], [Descriptor], [ArchiveFG], [DPMapping], [IndigoClientId], [ConcurrencyId])
        SELECT 1, 'On or before 14 March 1989',1, NULL,NULL,1 UNION ALL 
        SELECT 2, 'On or after 15 March 1989',1, NULL,NULL,1 UNION ALL 
        SELECT 3, 'Not Sure',1, NULL,NULL,1 
 
        SET IDENTITY_INSERT TRefSchemeSetUp OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'AF39E5D9-E6B2-4BFF-B54D-ABF08BDA03D3', 
         'Initial load (3 total rows, file 1 of 1) for table TRefSchemeSetUp',
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
