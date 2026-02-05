 
-----------------------------------------------------------------------------
-- Table: Administration.TDashboardPermissions
--    Join: join tdashboardlayout l on l.dashboardid = tdashboardpermissions.DashboardId
--   Where: WHERE l.TenantId = 466
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '65B4E631-B084-426C-BF81-2D9C7E8EFA62'
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
        SET IDENTITY_INSERT TDashboardPermissions ON; 
 
        INSERT INTO TDashboardPermissions([DashboardPermissionsId], [DashboardId], [RoleId], [isAllowed], [ConcurrencyId])
        SELECT 14493,'B295A06B-FA23-4325-887D-D96325FD4BD1',4010,1,1 UNION ALL 
        SELECT 20242,'EF96510C-0BEE-4D22-B12E-775C5513510B',4010,1,1 UNION ALL 
        SELECT 66046,'8C4C5FC3-41E5-4726-875E-36D1B9D5D64C',4010,1,1 UNION ALL 
        SELECT 84009,'83DA7E50-27A7-4076-8CD0-C56FC128E1A5',4010,1,1 UNION ALL 
        SELECT 7895,'B295A06B-FA23-4325-887D-D96325FD4BD1',4011,1,1 UNION ALL 
        SELECT 66047,'8C4C5FC3-41E5-4726-875E-36D1B9D5D64C',4011,1,1 UNION ALL 
        SELECT 12809,'B295A06B-FA23-4325-887D-D96325FD4BD1',4012,1,1 UNION ALL 
        SELECT 66048,'8C4C5FC3-41E5-4726-875E-36D1B9D5D64C',4012,1,1 UNION ALL 
        SELECT 163,'B295A06B-FA23-4325-887D-D96325FD4BD1',4013,1,1 UNION ALL 
        SELECT 66049,'8C4C5FC3-41E5-4726-875E-36D1B9D5D64C',4013,1,1 UNION ALL 
        SELECT 11831,'B295A06B-FA23-4325-887D-D96325FD4BD1',4014,1,1 UNION ALL 
        SELECT 66045,'ABE9E3D8-9F46-4079-BACF-0116720E2EF0',4014,1,1 UNION ALL 
        SELECT 2611,'B295A06B-FA23-4325-887D-D96325FD4BD1',4015,1,1 UNION ALL 
        SELECT 66050,'8C4C5FC3-41E5-4726-875E-36D1B9D5D64C',4015,1,1 UNION ALL 
        SELECT 6544,'B295A06B-FA23-4325-887D-D96325FD4BD1',4016,1,1 UNION ALL 
        SELECT 66051,'8C4C5FC3-41E5-4726-875E-36D1B9D5D64C',4016,1,1 UNION ALL 
        SELECT 15332,'B295A06B-FA23-4325-887D-D96325FD4BD1',4017,1,1 UNION ALL 
        SELECT 66052,'8C4C5FC3-41E5-4726-875E-36D1B9D5D64C',4017,1,1 UNION ALL 
        SELECT 7257,'B295A06B-FA23-4325-887D-D96325FD4BD1',4018,1,1 UNION ALL 
        SELECT 66053,'8C4C5FC3-41E5-4726-875E-36D1B9D5D64C',4018,1,1 UNION ALL 
        SELECT 12012,'B295A06B-FA23-4325-887D-D96325FD4BD1',4019,1,1 UNION ALL 
        SELECT 66054,'8C4C5FC3-41E5-4726-875E-36D1B9D5D64C',4019,1,1 
 
        SET IDENTITY_INSERT TDashboardPermissions OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '65B4E631-B084-426C-BF81-2D9C7E8EFA62', 
         'Initial load (22 total rows, file 1 of 1) for table TDashboardPermissions',
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
-- #Rows Exported: 22
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
