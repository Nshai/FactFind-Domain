 
-----------------------------------------------------------------------------
-- Table: CRM.TPostCodePrimaryAllocationType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '72202F05-1F6F-4C4E-95B5-3DD52B6F4B49'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TPostCodePrimaryAllocationType ON; 
 
        INSERT INTO TPostCodePrimaryAllocationType([PrimaryAllocationTypeId], [PrimaryAllocationTypeName], [ConcurrencyId])
        SELECT 1, 'By Nearest Adviser',1 UNION ALL 
        SELECT 2, 'By Longest Without a Lead',1 UNION ALL 
        SELECT 3, 'By Postcode Patch',1 
 
        SET IDENTITY_INSERT TPostCodePrimaryAllocationType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '72202F05-1F6F-4C4E-95B5-3DD52B6F4B49', 
         'Initial load (3 total rows, file 1 of 1) for table TPostCodePrimaryAllocationType',
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
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
