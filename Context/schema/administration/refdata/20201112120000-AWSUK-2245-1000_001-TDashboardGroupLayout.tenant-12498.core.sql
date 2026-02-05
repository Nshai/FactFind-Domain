 
-----------------------------------------------------------------------------
-- Table: Administration.TDashboardGroupLayout
--    Join: join tdashboardlayout l on l.dashboardid = TDashboardGroupLayout.DashboardId
--   Where: WHERE TenantId = 12498
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'F7EC8EF9-A31F-47C0-B279-25E80FD880D0'
     AND TenantId = 12498
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
 
        INSERT INTO TDashboardGroupLayout([DashboardGroupId], [DashboardId], [DisplayOrder])
        SELECT 'D0DCED62-7866-4353-B5A8-8B2F5B245088','72E47DFA-2F8C-43DA-8F48-258B9F9DB8F1',0 UNION ALL 
        SELECT 'D0DCED62-7866-4353-B5A8-8B2F5B245088','0B09EA57-6447-42A3-9341-545A542293ED',2 UNION ALL 
        SELECT 'D0DCED62-7866-4353-B5A8-8B2F5B245088','C717DE6D-E7FD-4D48-A0E1-75AD782FA775',3 UNION ALL 
        SELECT 'D0DCED62-7866-4353-B5A8-8B2F5B245088','7DA6B859-AABB-4681-A821-F6ED200AEE62',1 UNION ALL 
        SELECT 'BF8B3773-CB46-48F1-B986-09050536EB40','2C7F1B4A-A531-4F71-8DDE-C578808FDB94',0 
 
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'F7EC8EF9-A31F-47C0-B279-25E80FD880D0', 
         'Initial load (5 total rows, file 1 of 1) for table TDashboardGroupLayout',
         12498, 
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
-- #Rows Exported: 5
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
