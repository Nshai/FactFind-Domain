 
-----------------------------------------------------------------------------
-- Table: Administration.TRefRecentSearchAndReportType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '3EC2FB64-ED08-4758-AFBC-980256E70A2E'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefRecentSearchAndReportType ON; 
 
        INSERT INTO TRefRecentSearchAndReportType([RefRecentSearchAndReportTypeId], [Identifier], [Archived], [ConcurrencyId])
        SELECT 1, 'Not Set',0,1 UNION ALL 
        SELECT 2, 'Recent N',0,1 UNION ALL 
        SELECT 3, 'Search',0,1 
 
        SET IDENTITY_INSERT TRefRecentSearchAndReportType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '3EC2FB64-ED08-4758-AFBC-980256E70A2E', 
         'Initial load (3 total rows, file 1 of 1) for table TRefRecentSearchAndReportType',
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
