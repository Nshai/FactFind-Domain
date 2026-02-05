 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefBasisOfSalaryTypes
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '0D227A23-5E8F-4179-9582-2B07159C18E6'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefBasisOfSalaryTypes ON; 
 
        INSERT INTO TRefBasisOfSalaryTypes([RefBasisOfSalaryTypesId], [Name])
        SELECT 1, 'Basic Salary' UNION ALL 
        SELECT 2, 'Basic Salary Plus Bonuses' UNION ALL 
        SELECT 3, 'P60 Earnings' UNION ALL 
        SELECT 4, 'P60 + Bonuses' UNION ALL 
        SELECT 5, 'Salary at last Renewal' UNION ALL 
        SELECT 6, 'Other' UNION ALL 
        SELECT 7, 'Qualifying Earnings' 
 
        SET IDENTITY_INSERT TRefBasisOfSalaryTypes OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '0D227A23-5E8F-4179-9582-2B07159C18E6', 
         'Initial load (7 total rows, file 1 of 1) for table TRefBasisOfSalaryTypes',
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
-- #Rows Exported: 7
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
