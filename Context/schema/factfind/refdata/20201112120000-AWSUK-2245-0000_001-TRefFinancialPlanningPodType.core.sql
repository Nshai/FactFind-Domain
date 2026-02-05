 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefFinancialPlanningPodType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '48D6F06C-2399-4AD9-8AD2-A8BB149D924A'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefFinancialPlanningPodType ON; 
 
        INSERT INTO TRefFinancialPlanningPodType([RefFinancialPlanningPodTypeId], [Description], [PodImageType], [ConcurrencyId])
        SELECT 1, 'Default Pod image', 'PodImage',1 UNION ALL 
        SELECT 8, 'Smudge Image', 'SmudgeImage',1 UNION ALL 
        SELECT 9, 'Speedo Image', 'SpeedoImage',1 
 
        SET IDENTITY_INSERT TRefFinancialPlanningPodType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '48D6F06C-2399-4AD9-8AD2-A8BB149D924A', 
         'Initial load (3 total rows, file 1 of 1) for table TRefFinancialPlanningPodType',
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
