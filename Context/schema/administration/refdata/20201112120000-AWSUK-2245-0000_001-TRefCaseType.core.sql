 
-----------------------------------------------------------------------------
-- Table: Administration.TRefCaseType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '7B5A311D-B527-4A7F-B3BB-7488573F2F81'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefCaseType ON; 
 
        INSERT INTO TRefCaseType([RefCaseTypeId], [CaseTypeName], [ConcurrencyId])
        SELECT 1, 'Defect',1 UNION ALL 
        SELECT 2, 'Training',1 UNION ALL 
        SELECT 3, 'Configuration by Intelliflo',1 UNION ALL 
        SELECT 4, 'Data Error',1 UNION ALL 
        SELECT 5, 'Enhancement',1 UNION ALL 
        SELECT 6, 'Implementation ',1 UNION ALL 
        SELECT 7, 'Data Migration',1 
 
        SET IDENTITY_INSERT TRefCaseType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '7B5A311D-B527-4A7F-B3BB-7488573F2F81', 
         'Initial load (7 total rows, file 1 of 1) for table TRefCaseType',
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
-- #Rows Exported: 7
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
