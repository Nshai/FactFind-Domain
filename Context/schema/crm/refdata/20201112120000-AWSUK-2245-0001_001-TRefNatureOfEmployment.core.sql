 
-----------------------------------------------------------------------------
-- Table: CRM.TRefNatureOfEmployment
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'D74666D9-75B2-4A26-AF1F-94438A3CD5C2'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefNatureOfEmployment ON; 
 
        INSERT INTO TRefNatureOfEmployment([RefNatureOfEmploymentId], [Name], [Extensible], [ConcurrencyId])
        SELECT 4, 'Office Based',NULL,1 UNION ALL 
        SELECT 3, 'Driving',NULL,1 UNION ALL 
        SELECT 2, 'Administrative',NULL,1 UNION ALL 
        SELECT 1, 'Manual',NULL,1 
 
        SET IDENTITY_INSERT TRefNatureOfEmployment OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'D74666D9-75B2-4A26-AF1F-94438A3CD5C2', 
         'Initial load (4 total rows, file 1 of 1) for table TRefNatureOfEmployment',
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
-- #Rows Exported: 4
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
