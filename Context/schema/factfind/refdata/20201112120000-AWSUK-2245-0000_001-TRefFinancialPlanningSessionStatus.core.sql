 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefFinancialPlanningSessionStatus
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'D4844371-8630-4CDD-A8F7-AB9CEDB355F7'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefFinancialPlanningSessionStatus ON; 
 
        INSERT INTO TRefFinancialPlanningSessionStatus([RefFinancialPlanningSessionStatusId], [Description], [ConcurrencyId])
        SELECT 1, 'Draft',1 UNION ALL 
        SELECT 2, 'Final',1 UNION ALL 
        SELECT 3, 'Locked',1 
 
        SET IDENTITY_INSERT TRefFinancialPlanningSessionStatus OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'D4844371-8630-4CDD-A8F7-AB9CEDB355F7', 
         'Initial load (3 total rows, file 1 of 1) for table TRefFinancialPlanningSessionStatus',
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
