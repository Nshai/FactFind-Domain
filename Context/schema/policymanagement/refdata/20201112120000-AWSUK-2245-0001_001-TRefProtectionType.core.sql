 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefProtectionType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '0FBE2044-941A-4019-9447-A1A5DC3E4DFF'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefProtectionType ON; 
 
        INSERT INTO TRefProtectionType([RefProtectionTypeId], [Name])
        SELECT 1, 'No' UNION ALL 
        SELECT 2, 'Life' UNION ALL 
        SELECT 3, 'CIC' UNION ALL 
        SELECT 4, 'ASU' UNION ALL 
        SELECT 5, 'LifeCIC' UNION ALL 
        SELECT 6, 'LifeASU' UNION ALL 
        SELECT 7, 'CICASU' UNION ALL 
        SELECT 8, 'LifeCICASU' 
 
        SET IDENTITY_INSERT TRefProtectionType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '0FBE2044-941A-4019-9447-A1A5DC3E4DFF', 
         'Initial load (8 total rows, file 1 of 1) for table TRefProtectionType',
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
-- #Rows Exported: 8
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
