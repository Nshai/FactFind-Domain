 
-----------------------------------------------------------------------------
-- Table: Administration.TRole
--    Join: 
--   Where: WHERE IndigoClientId = 12498
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '7C21ABC6-590B-464C-9804-B27EBC05E402'
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
        SET IDENTITY_INSERT TRole ON; 
 
        INSERT INTO TRole([RoleId], [Identifier], [GroupingId], [SuperUser], [IndigoClientId], [RefLicenseTypeId], [LicensedUserCount], [Dashboard], [ShowGroupDashboard], [ConcurrencyId], [HourlyBillingRate])
        SELECT 34609, 'System Administrator',4955,1,12498,1,0, 'administratorDashboard',1,1,NULL UNION ALL 
        SELECT 34610, 'TnC Coach',4955,0,12498,1,0, 'administratorDashboard',0,2,NULL UNION ALL 
        SELECT 34611, 'Adviser',4955,0,12498,1,0, 'adviserDashboard',0,2,NULL UNION ALL 
        SELECT 34612, 'Administrator',4955,0,12498,1,0, 'administratorDashboard',0,2,NULL UNION ALL 
        SELECT 34614, 'Income Manager',4955,0,12498,1,0, 'administratorDashboard',1,4,NULL UNION ALL 
        SELECT 34615, 'Compliance Manager',4955,0,12498,1,0, 'administratorDashboard',1,3,NULL UNION ALL 
        SELECT 39379, 'iostoreAdmin',4955,0,12498,1,0, NULL,0,1,NULL UNION ALL 
        SELECT 51478, 'iostoreGroupAdmin',4955,0,12498,1,0, NULL,0,1,NULL UNION ALL 
        SELECT 53965, 'Paraplanner',4955,0,12498,1,0, 'administratorDashboard',0,1,NULL UNION ALL 
        SELECT 53966, 'Manager',4955,0,12498,1,0, 'administratorDashboard',0,1,NULL 
 
        SET IDENTITY_INSERT TRole OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '7C21ABC6-590B-464C-9804-B27EBC05E402', 
         'Initial load (10 total rows, file 1 of 1) for table TRole',
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
-- #Rows Exported: 10
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
