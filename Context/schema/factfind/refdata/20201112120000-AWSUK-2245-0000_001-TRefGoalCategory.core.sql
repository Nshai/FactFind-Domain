 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefGoalCategory
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '863AF178-6D4D-41E5-B10A-B13B132C4CD1'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefGoalCategory ON; 
 
        INSERT INTO TRefGoalCategory([RefGoalCategoryId], [Name], [ConcurrencyId], [Ordinal])
        SELECT 1, 'Travel & Holidays',0,2 UNION ALL 
        SELECT 2, 'Mortgage Repayment',0,3 UNION ALL 
        SELECT 3, 'Self Indulgence',0,4 UNION ALL 
        SELECT 4, 'Property Purchase',0,5 UNION ALL 
        SELECT 5, 'Education',0,6 UNION ALL 
        SELECT 6, 'Income',0,7 UNION ALL 
        SELECT 7, 'Other',0,1 UNION ALL 
        SELECT 8, 'At Retirement Income',0,8 
 
        SET IDENTITY_INSERT TRefGoalCategory OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '863AF178-6D4D-41E5-B10A-B13B132C4CD1', 
         'Initial load (8 total rows, file 1 of 1) for table TRefGoalCategory',
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
-- #Rows Exported: 8
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
