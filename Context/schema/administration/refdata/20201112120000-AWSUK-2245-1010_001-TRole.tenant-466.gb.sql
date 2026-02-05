 
-----------------------------------------------------------------------------
-- Table: Administration.TRole
--    Join: 
--   Where: WHERE IndigoClientId = 466
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '7C21ABC6-590B-464C-9804-B27EBC05E402'
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
        SET IDENTITY_INSERT TRole ON; 
 
        INSERT INTO TRole([RoleId], [Identifier], [GroupingId], [SuperUser], [IndigoClientId], [RefLicenseTypeId], [LicensedUserCount], [Dashboard], [ShowGroupDashboard], [ConcurrencyId], [HourlyBillingRate])
        SELECT 4010, 'System Administrator',589,1,466,1,0, 'administratorDashboard',1,2,NULL UNION ALL 
        SELECT 4011, 'G60 Specialist',589,0,466,1,0, 'administratorDashboard',0,1,NULL UNION ALL 
        SELECT 4012, 'Organisation Administrator',589,1,466,1,0, 'administratorDashboard',1,1,NULL UNION ALL 
        SELECT 4013, 'TnC Coach',589,0,466,1,0, 'administratorDashboard',0,1,NULL UNION ALL 
        SELECT 4014, 'Adviser',589,0,466,1,0, 'adviserDashboard',1,1,NULL UNION ALL 
        SELECT 4015, 'Administrator',589,1,466,1,0, 'administratorDashboard',1,1,NULL UNION ALL 
        SELECT 4016, 'Paraplanner',589,0,466,1,0, 'administratorDashboard',0,1,NULL UNION ALL 
        SELECT 4017, 'Manager',589,1,466,1,0, 'administratorDashboard',0,1,NULL UNION ALL 
        SELECT 4018, 'Commissions Manager',589,0,466,1,0, 'administratorDashboard',0,1,NULL UNION ALL 
        SELECT 4019, 'Compliance Manager',589,0,466,1,0, 'administratorDashboard',0,1,NULL UNION ALL 
        SELECT 37224, 'iostoreAdmin',589,0,466,1,0, NULL,0,1,NULL UNION ALL 
        SELECT 49587, 'iostoreGroupAdmin',589,0,466,1,0, NULL,0,1,NULL 
 
        SET IDENTITY_INSERT TRole OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '7C21ABC6-590B-464C-9804-B27EBC05E402', 
         'Initial load (12 total rows, file 1 of 1) for table TRole',
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
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
