 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefPlanTypeGrouping
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'A9F9FF5A-42BE-47B1-ABC5-8E9F8C35B3B6'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPlanTypeGrouping ON; 
 
        INSERT INTO TRefPlanTypeGrouping([RefPlanTypeGroupingId], [RefPlanTypeId], [IsMortgage], [IsTerm], [ConcurrencyId])
        SELECT 1,63,1,0,1 UNION ALL 
        SELECT 2,83,1,0,1 UNION ALL 
        SELECT 3,92,1,0,1 UNION ALL 
        SELECT 4,102,1,0,1 
 
        SET IDENTITY_INSERT TRefPlanTypeGrouping OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'A9F9FF5A-42BE-47B1-ABC5-8E9F8C35B3B6', 
         'Initial load (4 total rows, file 1 of 1) for table TRefPlanTypeGrouping',
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
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
