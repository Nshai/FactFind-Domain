 
-----------------------------------------------------------------------------
-- Table: CRM.TAdviceCaseStatusChange
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'C3750B02-301A-4542-8399-0ECAC93758C5'
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
        SET IDENTITY_INSERT TAdviceCaseStatusChange ON; 
 
        INSERT INTO TAdviceCaseStatusChange([AdviceCaseStatusChangeId], [IndigoClientId], [AdviceCaseStatusIdFrom], [AdviceCaseStatusIdTo], [ConcurrencyId])
        SELECT 877,466,321,803,1 UNION ALL 
        SELECT 878,466,803,1285,1 UNION ALL 
        SELECT 879,466,1285,803,1 UNION ALL 
        SELECT 880,466,803,321,1 
 
        SET IDENTITY_INSERT TAdviceCaseStatusChange OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'C3750B02-301A-4542-8399-0ECAC93758C5', 
         'Initial load (4 total rows, file 1 of 1) for table TAdviceCaseStatusChange',
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
-- #Rows Exported: 4
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
