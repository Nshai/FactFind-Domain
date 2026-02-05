 
-----------------------------------------------------------------------------
-- Table: CRM.TRefFactFindSearchType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '73E2275F-8578-4B81-B8A6-78E4DD07EFAF'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefFactFindSearchType ON; 
 
        INSERT INTO TRefFactFindSearchType([RefFactFindSearchTypeId], [SearchTypeName], [AllPlanTypes], [ConcurrencyId])
        SELECT 4, 'Retirement',0,1 UNION ALL 
        SELECT 3, 'Protection',0,1 UNION ALL 
        SELECT 2, 'Savings & Investments',0,1 UNION ALL 
        SELECT 1, 'All Plan Types',1,1 
 
        SET IDENTITY_INSERT TRefFactFindSearchType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '73E2275F-8578-4B81-B8A6-78E4DD07EFAF', 
         'Initial load (4 total rows, file 1 of 1) for table TRefFactFindSearchType',
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
