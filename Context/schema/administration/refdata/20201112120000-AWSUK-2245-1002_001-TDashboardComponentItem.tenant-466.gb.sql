 
-----------------------------------------------------------------------------
-- Table: Administration.TDashboardComponentItem
--    Join: 
--   Where: WHERE TenantId = 466
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '6AED2737-0FE4-447F-ABEA-1C06DC019AAD'
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
        SET IDENTITY_INSERT TDashboardComponentItem ON; 
 
        INSERT INTO TDashboardComponentItem([DashboardComponentItemId], [DashboardComponentId], [TenantId], [ItemName], [Description], [Value], [ConcurrencyId])
        SELECT 1846,13,466, 'Plans Failed', NULL, NULL,1 UNION ALL 
        SELECT 828,13,466, 'Plans passed', NULL, NULL,1 UNION ALL 
        SELECT 1337,13,466, 'Plans passed with learning points', NULL, NULL,1 UNION ALL 
        SELECT 319,13,466, 'Plans requiring remedial work', NULL, NULL,1 
 
        SET IDENTITY_INSERT TDashboardComponentItem OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '6AED2737-0FE4-447F-ABEA-1C06DC019AAD', 
         'Initial load (4 total rows, file 1 of 1) for table TDashboardComponentItem',
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
