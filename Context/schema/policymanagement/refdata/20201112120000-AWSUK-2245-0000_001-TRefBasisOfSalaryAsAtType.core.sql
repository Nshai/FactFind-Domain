 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefBasisOfSalaryAsAtType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '8C35B0EA-C699-40C6-A037-2B0391E7F6DC'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefBasisOfSalaryAsAtType ON; 
 
        INSERT INTO TRefBasisOfSalaryAsAtType([RefBasisOfSalaryAsAtTypeId], [Name])
        SELECT 1, 'At Renewal' UNION ALL 
        SELECT 2, 'At Date of Death' UNION ALL 
        SELECT 3, 'At Date of Incapacity' 
 
        SET IDENTITY_INSERT TRefBasisOfSalaryAsAtType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '8C35B0EA-C699-40C6-A037-2B0391E7F6DC', 
         'Initial load (3 total rows, file 1 of 1) for table TRefBasisOfSalaryAsAtType',
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
-- #Rows Exported: 3
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
