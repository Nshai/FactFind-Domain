 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefRateType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '248263D4-EB74-485E-B84E-A545C7FD09CE'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefRateType ON; 
 
        INSERT INTO TRefRateType([RefRateTypeId], [Name])
        SELECT 1, 'Capped' UNION ALL 
        SELECT 2, 'Discount' UNION ALL 
        SELECT 3, 'Fixed' UNION ALL 
        SELECT 4, 'Flexible' UNION ALL 
        SELECT 5, 'LIBOR' UNION ALL 
        SELECT 6, 'OffsetRate' UNION ALL 
        SELECT 7, 'Standard' UNION ALL 
        SELECT 8, 'Tracker' UNION ALL 
        SELECT 9, 'Variable' 
 
        SET IDENTITY_INSERT TRefRateType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '248263D4-EB74-485E-B84E-A545C7FD09CE', 
         'Initial load (9 total rows, file 1 of 1) for table TRefRateType',
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
-- #Rows Exported: 9
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
