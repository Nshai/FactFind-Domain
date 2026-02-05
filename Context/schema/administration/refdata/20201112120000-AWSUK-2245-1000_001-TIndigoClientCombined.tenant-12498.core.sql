 
-----------------------------------------------------------------------------
-- Table: Administration.TIndigoClientCombined
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '6B3A0F42-77C3-4C27-B0D0-43DA27B4C2F3'
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
 
        INSERT INTO TIndigoClientCombined([Guid], [IndigoClientId], [Identifier], [RefEnvironmentId], [IsPortfolioConstructionProvider], [IsAuthorProvider], [IsAtrProvider], [ConcurrencyId], [msrepl_tran_version])
        SELECT '14015FB2-5EDC-497E-ACD7-91925877F8DC',12498, 'Intelliflo Ltd (Wealth Account)',1,0,0,0,1,'957B25B1-B997-4B3A-BEF4-1CB02022704F' 
 
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '6B3A0F42-77C3-4C27-B0D0-43DA27B4C2F3', 
         'Initial load (1 total rows, file 1 of 1) for table TIndigoClientCombined',
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
-- #Rows Exported: 1
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
