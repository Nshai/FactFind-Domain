 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefFinancialPlanningAssetColour
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '1F15767C-4EB2-4DD7-B533-A6CFBD9E9FC3'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefFinancialPlanningAssetColour ON; 
 
        INSERT INTO TRefFinancialPlanningAssetColour([RefFinancialPlanningAssetColourId], [AssetDescription], [AssetSeriesNumber], [AssetColour], [ConcurrencyId])
        SELECT 6, 'UK Equities',3, '#827AFF',1 UNION ALL 
        SELECT 5, 'Specialist Equity',5, '#17852D',1 UNION ALL 
        SELECT 4, 'Property',1, '#E5B81F',1 UNION ALL 
        SELECT 3, 'Overseas Equity',4, '#ED761A',1 UNION ALL 
        SELECT 2, 'Fixed Interest',2, '#0D06C2',1 UNION ALL 
        SELECT 1, 'Cash',0, '#ED2B1A',1 
 
        SET IDENTITY_INSERT TRefFinancialPlanningAssetColour OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '1F15767C-4EB2-4DD7-B533-A6CFBD9E9FC3', 
         'Initial load (6 total rows, file 1 of 1) for table TRefFinancialPlanningAssetColour',
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
-- #Rows Exported: 6
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
