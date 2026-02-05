 
-----------------------------------------------------------------------------
-- Table: CRM.TPostCodeSecondaryAllocationType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'BBC27ACA-2623-45B6-9540-3EBB246B340B'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TPostCodeSecondaryAllocationType ON; 
 
        INSERT INTO TPostCodeSecondaryAllocationType([SecondaryAllocationTypeId], [SecondaryAllocationTypeName], [ConcurrencyId])
        SELECT 1, 'By Nearest Adviser',1 UNION ALL 
        SELECT 2, 'By Longest Without a Lead',1 
 
        SET IDENTITY_INSERT TPostCodeSecondaryAllocationType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'BBC27ACA-2623-45B6-9540-3EBB246B340B', 
         'Initial load (2 total rows, file 1 of 1) for table TPostCodeSecondaryAllocationType',
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
-- #Rows Exported: 2
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
