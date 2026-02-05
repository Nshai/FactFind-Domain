 
-----------------------------------------------------------------------------
-- Table: Administration.TDashboardGroupLayout
--    Join: join tdashboardlayout l on l.dashboardid = TDashboardGroupLayout.DashboardId
--   Where: WHERE TenantId = 466
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'F7EC8EF9-A31F-47C0-B279-25E80FD880D0'
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
 
        INSERT INTO TDashboardGroupLayout([DashboardGroupId], [DashboardId], [DisplayOrder])
        SELECT 'FDA8B281-959B-4024-BA26-5244D1586EBD','EF96510C-0BEE-4D22-B12E-775C5513510B',2 UNION ALL 
        SELECT 'FDA8B281-959B-4024-BA26-5244D1586EBD','B295A06B-FA23-4325-887D-D96325FD4BD1',3 UNION ALL 
        SELECT '97E63B59-2E1C-4AA2-AFA4-9241D20D0C94','83DA7E50-27A7-4076-8CD0-C56FC128E1A5',0 UNION ALL 
        SELECT 'FDA8B281-959B-4024-BA26-5244D1586EBD','ABE9E3D8-9F46-4079-BACF-0116720E2EF0',0 UNION ALL 
        SELECT 'FDA8B281-959B-4024-BA26-5244D1586EBD','8C4C5FC3-41E5-4726-875E-36D1B9D5D64C',1 
 
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'F7EC8EF9-A31F-47C0-B279-25E80FD880D0', 
         'Initial load (5 total rows, file 1 of 1) for table TDashboardGroupLayout',
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
-- #Rows Exported: 5
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
