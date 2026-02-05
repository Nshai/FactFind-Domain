 
-----------------------------------------------------------------------------
-- Table: Administration.TRefEnvironment
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '5DEFC235-8F54-4810-A0CD-892079755624'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefEnvironment ON; 
 
        INSERT INTO TRefEnvironment([RefEnvironmentId], [URL], [ConcurrencyId])
        SELECT 1, 'https://www.site10.intelligent-office.net/nio/authentication/login',1 UNION ALL 
        SELECT 2, 'https://www.site20.intelligent-office.net/nio/authentication/login',1 UNION ALL 
        SELECT 5, 'https://t-r3-www.intelliflo.local/nio/authentication/login',1 UNION ALL 
        SELECT 6, 'https://t-r3-www.site20.intelliflo.local/nio/authentication/login',1 
 
        SET IDENTITY_INSERT TRefEnvironment OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '5DEFC235-8F54-4810-A0CD-892079755624', 
         'Initial load (4 total rows, file 1 of 1) for table TRefEnvironment',
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
