 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefPlanningType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '3AD7B25A-81E2-47D7-BC01-C31DF8BFEDA8'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPlanningType ON; 
 
        INSERT INTO TRefPlanningType([RefPlanningTypeId], [PlanningType], [ConcurrencyId])
        SELECT 2, 'Pension',0 UNION ALL 
        SELECT 1, 'Investment',0 UNION ALL 
        SELECT 3, 'Dynamic Planner',0 UNION ALL 
        SELECT 4, 'Advisacenta',1 
 
        SET IDENTITY_INSERT TRefPlanningType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '3AD7B25A-81E2-47D7-BC01-C31DF8BFEDA8', 
         'Initial load (4 total rows, file 1 of 1) for table TRefPlanningType',
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
