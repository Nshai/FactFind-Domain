 
-----------------------------------------------------------------------------
-- Table: Administration.TDashboardPermissions
--    Join: join tdashboardlayout l on l.dashboardid = tdashboardpermissions.DashboardId
--   Where: WHERE l.TenantId = 12498
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '65B4E631-B084-426C-BF81-2D9C7E8EFA62'
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
        SET IDENTITY_INSERT TDashboardPermissions ON; 
 
        INSERT INTO TDashboardPermissions([DashboardPermissionsId], [DashboardId], [RoleId], [isAllowed], [ConcurrencyId])
        SELECT 147859,'7DA6B859-AABB-4681-A821-F6ED200AEE62',34609,1,1 UNION ALL 
        SELECT 147871,'2C7F1B4A-A531-4F71-8DDE-C578808FDB94',34609,1,1 UNION ALL 
        SELECT 147877,'0B09EA57-6447-42A3-9341-545A542293ED',34609,1,1 UNION ALL 
        SELECT 147878,'C717DE6D-E7FD-4D48-A0E1-75AD782FA775',34609,1,1 UNION ALL 
        SELECT 147860,'7DA6B859-AABB-4681-A821-F6ED200AEE62',34610,1,1 UNION ALL 
        SELECT 147867,'2C7F1B4A-A531-4F71-8DDE-C578808FDB94',34610,1,1 UNION ALL 
        SELECT 147876,'0B09EA57-6447-42A3-9341-545A542293ED',34610,1,1 UNION ALL 
        SELECT 147879,'C717DE6D-E7FD-4D48-A0E1-75AD782FA775',34610,1,1 UNION ALL 
        SELECT 147866,'72E47DFA-2F8C-43DA-8F48-258B9F9DB8F1',34611,1,1 UNION ALL 
        SELECT 147868,'2C7F1B4A-A531-4F71-8DDE-C578808FDB94',34611,1,1 UNION ALL 
        SELECT 147880,'C717DE6D-E7FD-4D48-A0E1-75AD782FA775',34611,1,1 UNION ALL 
        SELECT 147861,'7DA6B859-AABB-4681-A821-F6ED200AEE62',34612,1,1 UNION ALL 
        SELECT 147869,'2C7F1B4A-A531-4F71-8DDE-C578808FDB94',34612,1,1 UNION ALL 
        SELECT 147882,'C717DE6D-E7FD-4D48-A0E1-75AD782FA775',34612,1,1 UNION ALL 
        SELECT 147863,'7DA6B859-AABB-4681-A821-F6ED200AEE62',34614,1,1 UNION ALL 
        SELECT 147873,'2C7F1B4A-A531-4F71-8DDE-C578808FDB94',34614,1,1 UNION ALL 
        SELECT 147885,'C717DE6D-E7FD-4D48-A0E1-75AD782FA775',34614,1,1 UNION ALL 
        SELECT 147864,'7DA6B859-AABB-4681-A821-F6ED200AEE62',34615,1,1 UNION ALL 
        SELECT 147874,'2C7F1B4A-A531-4F71-8DDE-C578808FDB94',34615,1,1 UNION ALL 
        SELECT 147884,'C717DE6D-E7FD-4D48-A0E1-75AD782FA775',34615,1,1 UNION ALL 
        SELECT 196018,'C717DE6D-E7FD-4D48-A0E1-75AD782FA775',53965,1,1 UNION ALL 
        SELECT 196019,'2C7F1B4A-A531-4F71-8DDE-C578808FDB94',53965,1,1 UNION ALL 
        SELECT 196020,'7DA6B859-AABB-4681-A821-F6ED200AEE62',53965,1,1 UNION ALL 
        SELECT 196021,'C717DE6D-E7FD-4D48-A0E1-75AD782FA775',53966,1,1 UNION ALL 
        SELECT 196022,'2C7F1B4A-A531-4F71-8DDE-C578808FDB94',53966,1,1 UNION ALL 
        SELECT 196023,'7DA6B859-AABB-4681-A821-F6ED200AEE62',53966,1,1 
 
        SET IDENTITY_INSERT TDashboardPermissions OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '65B4E631-B084-426C-BF81-2D9C7E8EFA62', 
         'Initial load (26 total rows, file 1 of 1) for table TDashboardPermissions',
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
-- #Rows Exported: 26
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
