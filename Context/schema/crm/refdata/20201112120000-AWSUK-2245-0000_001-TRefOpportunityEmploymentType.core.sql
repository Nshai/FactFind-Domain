 
-----------------------------------------------------------------------------
-- Table: CRM.TRefOpportunityEmploymentType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'E9C5703B-22AC-4939-B6A7-966FE4EBD183'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefOpportunityEmploymentType ON; 
 
        INSERT INTO TRefOpportunityEmploymentType([RefOpportunityEmploymentTypeId], [Name], [ConcurrencyId])
        SELECT 1, 'Employed',1 UNION ALL 
        SELECT 2, 'Self Employed',1 UNION ALL 
        SELECT 3, 'Not Employed',1 UNION ALL 
        SELECT 4, 'Retired',1 
 
        SET IDENTITY_INSERT TRefOpportunityEmploymentType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'E9C5703B-22AC-4939-B6A7-966FE4EBD183', 
         'Initial load (4 total rows, file 1 of 1) for table TRefOpportunityEmploymentType',
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
