 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TAdviceType
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'E8BE58A1-0E9A-4C74-8261-00C4D610A888'
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
        SET IDENTITY_INSERT TAdviceType ON; 
 
        INSERT INTO TAdviceType([AdviceTypeId], [Description], [IntelligentOfficeAdviceType], [ArchiveFg], [IndigoClientId], [ConcurrencyId], [IsSystem])
        SELECT 6304, 'Pre-Existing Plan', 'Pre-Existing',0,466,1,0 UNION ALL 
        SELECT 6305, 'New Business - Investments', 'New Business - Investments',0,466,1,0 UNION ALL 
        SELECT 6306, 'New Business - Protection', 'New Business - Protection',0,466,1,0 UNION ALL 
        SELECT 6307, 'New Business - Mortgages', 'New Business - Mortgages',0,466,1,0 UNION ALL 
        SELECT 6308, 'New Business - Pension', 'New Business - Pension',0,466,1,0 UNION ALL 
        SELECT 22437, 'DLP', 'DLP',0,466,1,1 UNION ALL 
        SELECT 32779, 'New Business - Integration', 'New Business - Integration',1,466,1,1 
 
        SET IDENTITY_INSERT TAdviceType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'E8BE58A1-0E9A-4C74-8261-00C4D610A888', 
         'Initial load (7 total rows, file 1 of 1) for table TAdviceType',
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
-- #Rows Exported: 7
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
