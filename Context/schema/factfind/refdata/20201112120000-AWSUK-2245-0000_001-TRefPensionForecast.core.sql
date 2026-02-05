 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefPensionForecast
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '08CC1AD8-38AD-46C6-B347-C06B7D688CAE'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPensionForecast ON; 
 
        INSERT INTO TRefPensionForecast([RefPensionForecastId], [RefPensionForecastDescription], [ConcurrencyId])
        SELECT 5, 'Manual',0 UNION ALL 
        SELECT 4, 'eValue Estimation',0 UNION ALL 
        SELECT 3, 'Employment History',0 UNION ALL 
        SELECT 2, 'BR19 Projection',0 UNION ALL 
        SELECT 1, 'Average Contribution Assumption',0 
 
        SET IDENTITY_INSERT TRefPensionForecast OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '08CC1AD8-38AD-46C6-B347-C06B7D688CAE', 
         'Initial load (5 total rows, file 1 of 1) for table TRefPensionForecast',
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
-- #Rows Exported: 5
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
