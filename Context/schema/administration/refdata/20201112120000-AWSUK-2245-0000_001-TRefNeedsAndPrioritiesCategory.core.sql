 
-----------------------------------------------------------------------------
-- Table: Administration.TRefNeedsAndPrioritiesCategory
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '76D7DE13-06ED-492D-B50D-92B0083AC759'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefNeedsAndPrioritiesCategory ON; 
 
        INSERT INTO TRefNeedsAndPrioritiesCategory([RefNeedsAndPrioritiesCategoryId], [ConcurrencyId], [CategoryName], [Ordinal], [IsCorporate], [CategoryType])
        SELECT 1,1, 'Mortgage',1,0,'Personal' UNION ALL 
        SELECT 2,1, 'Protection',2,0,'Personal' UNION ALL 
        SELECT 3,1, 'Retirement',3,0,'Personal' UNION ALL 
        SELECT 4,1, 'Investment',4,0,'Personal' UNION ALL 
        SELECT 5,1, 'Estate Planning',5,0,'Personal' UNION ALL 
        SELECT 6,1, 'General',7,0,'Personal' UNION ALL 
        SELECT 7,1, 'Summary',6,0,'Personal' UNION ALL 
        SELECT 11,1, 'Protection',1,1,'Corporate' UNION ALL 
        SELECT 12,1, 'Retirement',2,1,'Corporate' UNION ALL 
        SELECT 13,1, 'Investment',3,1,'Corporate' UNION ALL 
        SELECT 14,1, 'General',4,1,'Corporate' 
 
        SET IDENTITY_INSERT TRefNeedsAndPrioritiesCategory OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '76D7DE13-06ED-492D-B50D-92B0083AC759', 
         'Initial load (11 total rows, file 1 of 1) for table TRefNeedsAndPrioritiesCategory',
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
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
