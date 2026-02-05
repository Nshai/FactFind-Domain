 
-----------------------------------------------------------------------------
-- Table: CRM.TAdviceCaseStatus
--    Join: 
--   Where: WHERE TenantId=466
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '33640212-F411-4DA7-B7BC-0D22E3BDA338'
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
        SET IDENTITY_INSERT TAdviceCaseStatus ON; 
 
        INSERT INTO TAdviceCaseStatus([AdviceCaseStatusId], [TenantId], [Descriptor], [IsDefault], [IsComplete], [ConcurrencyId], [IsAutoClose])
        SELECT 321,466, 'Draft',1,0,1,0 UNION ALL 
        SELECT 803,466, 'In Process',0,0,1,0 UNION ALL 
        SELECT 1285,466, 'Complete',0,1,1,0 
 
        SET IDENTITY_INSERT TAdviceCaseStatus OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '33640212-F411-4DA7-B7BC-0D22E3BDA338', 
         'Initial load (3 total rows, file 1 of 1) for table TAdviceCaseStatus',
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
-- #Rows Exported: 3
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
