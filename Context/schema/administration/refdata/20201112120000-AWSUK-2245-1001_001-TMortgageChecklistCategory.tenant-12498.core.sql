 
-----------------------------------------------------------------------------
-- Table: Administration.TMortgageChecklistCategory
--    Join: 
--   Where: WHERE TenantId=12498
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '513137E5-24F2-4002-9914-4F80E38234A0'
     AND TenantId = 12498
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TMortgageChecklistCategory ON; 
 
        INSERT INTO TMortgageChecklistCategory([MortgageChecklistCategoryId], [MortgageChecklistCategoryName], [TenantId], [ArchiveFG], [Ordinal], [SystemFG], [ConcurrencyId])
        SELECT 9936, 'General',12498,0,1,1,1 UNION ALL 
        SELECT 9937, 'Bridging Loans',12498,1,2,1,1 UNION ALL 
        SELECT 9938, 'Execution-Only',12498,1,3,1,1 
 
        SET IDENTITY_INSERT TMortgageChecklistCategory OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '513137E5-24F2-4002-9914-4F80E38234A0', 
         'Initial load (3 total rows, file 1 of 1) for table TMortgageChecklistCategory',
         12498, 
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
