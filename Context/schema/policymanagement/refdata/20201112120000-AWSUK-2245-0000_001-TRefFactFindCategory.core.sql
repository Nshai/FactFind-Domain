 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefFactFindCategory
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '408DEC80-96C4-481A-9DB8-5604D24005EB'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefFactFindCategory ON; 
 
        INSERT INTO TRefFactFindCategory([RefFactFindCategoryId], [Identfier], [ConcurrencyId])
        SELECT 5, 'Mortgage',1 UNION ALL 
        SELECT 4, 'Pensions',1 UNION ALL 
        SELECT 3, 'Protection',1 UNION ALL 
        SELECT 2, 'Investments',1 UNION ALL 
        SELECT 1, 'All Plan Types',1 
 
        SET IDENTITY_INSERT TRefFactFindCategory OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '408DEC80-96C4-481A-9DB8-5604D24005EB', 
         'Initial load (5 total rows, file 1 of 1) for table TRefFactFindCategory',
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
