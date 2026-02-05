 
-----------------------------------------------------------------------------
-- Table: Administration.TIndigoClientLicense
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'CBFCF5F9-FA49-421F-8E8A-46E9CE1B8D72'
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
        SET IDENTITY_INSERT TIndigoClientLicense ON; 
 
        INSERT INTO TIndigoClientLicense([IndigoClientLicenseId], [IndigoClientId], [LicenseTypeId], [Status], [MaxConUsers], [MaxULAGCount], [UADRestriction], [MaxULADCount], [AdviserCountRestrict], [MaxAdviserCount], [MaxFinancialPlanningUsers], [ConcurrencyId], [MaxAdvisaCentaCoreUsers], [MaxAdvisaCentaCorePlusLifetimePlannerUsers])
        SELECT 3778,12498,1,1,NULL,10,0,0,0,0,0,1,NULL,NULL 
 
        SET IDENTITY_INSERT TIndigoClientLicense OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'CBFCF5F9-FA49-421F-8E8A-46E9CE1B8D72', 
         'Initial load (1 total rows, file 1 of 1) for table TIndigoClientLicense',
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
-- #Rows Exported: 1
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
