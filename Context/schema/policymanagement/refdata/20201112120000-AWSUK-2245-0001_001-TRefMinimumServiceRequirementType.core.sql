 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefMinimumServiceRequirementType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '3A4C2D95-47EA-420E-8685-73E56B0FBF21'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefMinimumServiceRequirementType ON; 
 
        INSERT INTO TRefMinimumServiceRequirementType([RefMinimumServiceRequirementTypeId], [Name])
        SELECT 1, 'Day' UNION ALL 
        SELECT 2, 'Week' UNION ALL 
        SELECT 3, 'Month' UNION ALL 
        SELECT 4, 'Year' UNION ALL 
        SELECT 5, 'Immediate' 
 
        SET IDENTITY_INSERT TRefMinimumServiceRequirementType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '3A4C2D95-47EA-420E-8685-73E56B0FBF21', 
         'Initial load (5 total rows, file 1 of 1) for table TRefMinimumServiceRequirementType',
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
-- #Rows Exported: 5
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
