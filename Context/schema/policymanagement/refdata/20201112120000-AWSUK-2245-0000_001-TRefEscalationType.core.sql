 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefEscalationType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '7D20F615-543C-43EB-83FF-4F5E93B8F6B7'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefEscalationType ON; 
 
        INSERT INTO TRefEscalationType([RefEscalationTypeId], [EscalationType], [RetireFg], [ConcurrencyId])
        SELECT 1, 'Fixed %',0,1 UNION ALL 
        SELECT 2, 'RPI',0,1 UNION ALL 
        SELECT 3, 'Level',0,1 UNION ALL 
        SELECT 4, 'NAEI',0,1 UNION ALL 
        SELECT 5, 'LPI',0,1 
 
        SET IDENTITY_INSERT TRefEscalationType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '7D20F615-543C-43EB-83FF-4F5E93B8F6B7', 
         'Initial load (5 total rows, file 1 of 1) for table TRefEscalationType',
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
