 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefMortgageProcurementFeeDueType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '5BA838A8-647B-4019-B497-76B5B93DB09C'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefMortgageProcurementFeeDueType ON; 
 
        INSERT INTO TRefMortgageProcurementFeeDueType([RefMortgageProcurementFeeDueTypeId], [Name], [ConcurrencyId])
        SELECT 1, 'On Offer',1 UNION ALL 
        SELECT 2, 'On Exchange',1 UNION ALL 
        SELECT 3, 'On Completion',1 UNION ALL 
        SELECT 4, 'On Pay run',1 UNION ALL 
        SELECT 5, 'After Complete',1 
 
        SET IDENTITY_INSERT TRefMortgageProcurementFeeDueType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '5BA838A8-647B-4019-B497-76B5B93DB09C', 
         'Initial load (5 total rows, file 1 of 1) for table TRefMortgageProcurementFeeDueType',
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
