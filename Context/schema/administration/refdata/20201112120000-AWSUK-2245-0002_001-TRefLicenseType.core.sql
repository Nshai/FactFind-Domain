 
-----------------------------------------------------------------------------
-- Table: Administration.TRefLicenseType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'D43AE991-20EE-4DBC-986E-900F88098AD1'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefLicenseType ON; 
 
        INSERT INTO TRefLicenseType([RefLicenseTypeId], [LicenseTypeName], [RefLicenseStatusId], [ConcurrencyId])
        SELECT 0, 'Master',1,1 UNION ALL 
        SELECT 1, 'Full',1,1 UNION ALL 
        SELECT 2, 'Mortgage',1,1 UNION ALL 
        SELECT 3, 'Introducer',1,1 UNION ALL 
        SELECT 4, 'MortgageAdmin',1,3 UNION ALL 
        SELECT 5, 'Lighthouse',1,1 UNION ALL 
        SELECT 6, 'Workflow',1,1 UNION ALL 
        SELECT 10, 'full archived',4,1 UNION ALL 
        SELECT 11, 'Branch Administrator (Nationwide)',4,1 UNION ALL 
        SELECT 12, 'lighthouse',4,1 
 
        SET IDENTITY_INSERT TRefLicenseType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'D43AE991-20EE-4DBC-986E-900F88098AD1', 
         'Initial load (10 total rows, file 1 of 1) for table TRefLicenseType',
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
-- #Rows Exported: 10
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
