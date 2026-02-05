 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TPlanCategory
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '7C6FD16C-711A-4972-9683-19BE204CE556'
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
        SET IDENTITY_INSERT TPlanCategory ON; 
 
        INSERT INTO TPlanCategory([PlanCategoryId], [PlanCategoryName], [RetireFg], [IndigoClientId], [Extensible], [ConcurrencyId])
        SELECT 2569, 'Non-Investment Insurance',0,466,NULL,1 UNION ALL 
        SELECT 2904, 'Non-Regulated',0,466,NULL,1 UNION ALL 
        SELECT 3574, 'Retail Investments',0,466,NULL,1 UNION ALL 
        SELECT 3239, 'Regulated Mortgage Contracts',0,466,NULL,1 
 
        SET IDENTITY_INSERT TPlanCategory OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '7C6FD16C-711A-4972-9683-19BE204CE556', 
         'Initial load (4 total rows, file 1 of 1) for table TPlanCategory',
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
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
