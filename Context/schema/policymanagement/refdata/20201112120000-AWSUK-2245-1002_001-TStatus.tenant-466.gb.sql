 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TStatus
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '9437ED91-60CA-4BD2-9459-D28F0999E2A0'
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
        SET IDENTITY_INSERT TStatus ON; 
 
        INSERT INTO TStatus([StatusId], [Name], [OrigoStatusId], [IntelligentOfficeStatusType], [PreComplianceCheck], [PostComplianceCheck], [SystemSubmitFg], [IndigoClientId], [ConcurrencyId], [IsPipelineStatus])
        SELECT 3869, 'Deleted',NULL, 'Deleted',0,0,0,466,1,0 UNION ALL 
        SELECT 3870, 'Draft',NULL, 'Draft',0,0,0,466,1,1 UNION ALL 
        SELECT 3871, 'G60 sign off',NULL, 'G60 sign off',0,0,0,466,1,1 UNION ALL 
        SELECT 3872, 'In force',8, 'In force',0,0,0,466,1,1 UNION ALL 
        SELECT 3873, 'NTU',NULL, 'NTU',0,0,0,466,1,0 UNION ALL 
        SELECT 3874, 'Out of Force',NULL, 'Off Risk',0,0,0,466,1,0 UNION ALL 
        SELECT 3875, 'Offer Made',NULL, 'Offer Made',0,0,0,466,1,1 UNION ALL 
        SELECT 17213, 'Paid Up',NULL, 'Paid Up',0,0,0,466,1,1 UNION ALL 
        SELECT 3876, 'Rejected',NULL, 'Rejected',0,0,0,466,1,0 UNION ALL 
        SELECT 3877, 'Submitted to Provider',NULL, 'Submitted to Provider',0,1,1,466,1,1 UNION ALL 
        SELECT 3878, 'Compliance Sign off',NULL, 'Submitted To T and C',1,0,0,466,1,1 UNION ALL 
        SELECT 3879, 'Underwriting',NULL, 'Underwriting',0,0,0,466,1,1 
 
        SET IDENTITY_INSERT TStatus OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '9437ED91-60CA-4BD2-9459-D28F0999E2A0', 
         'Initial load (12 total rows, file 1 of 1) for table TStatus',
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
-- #Rows Exported: 12
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
