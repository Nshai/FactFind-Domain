 
-----------------------------------------------------------------------------
-- Table: Administration.TRefCasePriority
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '6BDE0338-973E-468E-8217-64872374B359'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefCasePriority ON; 
 
        INSERT INTO TRefCasePriority([RefCasePriorityId], [CasePriorityName], [IsDefectPriority], [ConcurrencyId])
        SELECT 7, 'D - Low',0,1 UNION ALL 
        SELECT 6, 'C - Medium',0,1 UNION ALL 
        SELECT 5, 'B - High',0,1 UNION ALL 
        SELECT 4, 'A - Defect - Severity 4',1,1 UNION ALL 
        SELECT 3, 'A - Defect - Severity 3',1,1 UNION ALL 
        SELECT 2, 'A - Defect - Severity 2',1,1 UNION ALL 
        SELECT 1, 'A - Defect - Severity 1',1,1 
 
        SET IDENTITY_INSERT TRefCasePriority OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '6BDE0338-973E-468E-8217-64872374B359', 
         'Initial load (7 total rows, file 1 of 1) for table TRefCasePriority',
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
