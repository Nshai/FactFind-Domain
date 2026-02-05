 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValWrapperPlanType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'A2A0B44F-37DA-449A-B9DB-E55FCB462707'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TValWrapperPlanType ON; 
 
        INSERT INTO TValWrapperPlanType([ValWrapperPlanTypeId], [ValGatingId], [RefPlanType2ProdSubTypeId], [ConcurrencyId])
        SELECT 6,820,143,1 UNION ALL 
        SELECT 5,340,1000,1 UNION ALL 
        SELECT 4,340,1001,1 UNION ALL 
        SELECT 3,340,125,1 UNION ALL 
        SELECT 2,340,141,1 UNION ALL 
        SELECT 1,340,144,1 UNION ALL 
        SELECT 7,1691,143,1 UNION ALL 
        SELECT 8,1059,143,1 
 
        SET IDENTITY_INSERT TValWrapperPlanType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'A2A0B44F-37DA-449A-B9DB-E55FCB462707', 
         'Initial load (8 total rows, file 1 of 1) for table TValWrapperPlanType',
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
-- #Rows Exported: 8
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
