 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefPropertyType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '379884C9-B672-4C1B-A2EB-9E3CB102A219'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPropertyType ON; 
 
        INSERT INTO TRefPropertyType([RefPropertyTypeId], [Name], [ConcurrencyId])
        SELECT 1, 'Detached',1 UNION ALL 
        SELECT 2, 'Semi-Detached',1 UNION ALL 
        SELECT 3, 'Terraced',1 UNION ALL 
        SELECT 4, 'Purpose Built Flat',1 UNION ALL 
        SELECT 5, 'Converted Flat',1 UNION ALL 
        SELECT 6, 'Purpose Built Maisonette',1 UNION ALL 
        SELECT 7, 'Converted Maisonette',1 UNION ALL 
        SELECT 8, 'Over a Shop',1 UNION ALL 
        SELECT 9, 'Studio Flat',1 UNION ALL 
        SELECT 10, 'Flat over four storeys',1 UNION ALL 
        SELECT 11, 'Listed Building',1 
 
        SET IDENTITY_INSERT TRefPropertyType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '379884C9-B672-4C1B-A2EB-9E3CB102A219', 
         'Initial load (11 total rows, file 1 of 1) for table TRefPropertyType',
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
-- #Rows Exported: 11
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
