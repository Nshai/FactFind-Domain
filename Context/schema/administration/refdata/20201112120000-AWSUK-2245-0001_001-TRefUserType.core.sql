 
-----------------------------------------------------------------------------
-- Table: Administration.TRefUserType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'F19943C7-C314-47FC-80DF-A4F827888526'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefUserType ON; 
 
        INSERT INTO TRefUserType([RefUserTypeId], [Identifier], [Url], [ConcurrencyId])
        SELECT 1, 'Standard User', '/nio/dashboard/userdashboard',1 UNION ALL 
        SELECT 2, 'Portal User', '/clientmanagement/contacts/clientportal/dashboard.asp',1 UNION ALL 
        SELECT 3, 'Introducer User', '/nio/dashboard/organiserdashboard',1 UNION ALL 
        SELECT 4, 'PFP User', 'PFP',1 UNION ALL 
        SELECT 5, 'System User', '',1 UNION ALL 
        SELECT 6, 'Intelliflo Support User', '',1 
 
        SET IDENTITY_INSERT TRefUserType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'F19943C7-C314-47FC-80DF-A4F827888526', 
         'Initial load (6 total rows, file 1 of 1) for table TRefUserType',
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
