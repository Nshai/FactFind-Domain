 
-----------------------------------------------------------------------------
-- Table: Administration.TRefRiskComment
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'BE99AB30-C03E-4469-8AF0-A1D2E30A01AB'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefRiskComment ON; 
 
        INSERT INTO TRefRiskComment([RefRiskCommentId], [RiskComment], [ConcurrencyId])
        SELECT 1, 'Do not show comments box',1 UNION ALL 
        SELECT 2, 'Always show comments box',1 UNION ALL 
        SELECT 3, 'Only if answer is No show comments box',1 UNION ALL 
        SELECT 4, 'Only if answer is Yes show comments box',1 
 
        SET IDENTITY_INSERT TRefRiskComment OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'BE99AB30-C03E-4469-8AF0-A1D2E30A01AB', 
         'Initial load (4 total rows, file 1 of 1) for table TRefRiskComment',
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
