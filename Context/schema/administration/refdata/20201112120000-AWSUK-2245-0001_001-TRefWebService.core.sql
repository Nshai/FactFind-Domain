 
-----------------------------------------------------------------------------
-- Table: Administration.TRefWebService
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '752BE3E6-F54C-4BE2-BF01-AACEDF075BF5'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefWebService ON; 
 
        INSERT INTO TRefWebService([RefWebServiceId], [Identifier], [URL], [ClassName], [MethodName], [NamedDataSource], [DenyAccess], [ConcurrencyId])
        SELECT 3, '665731AF-7D5C-4C99-81A6-29A43C807167', '/ClientManagementWS', 'Lead.asmx', 'AddLead', NULL,0,1 UNION ALL 
        SELECT 2, '9AC67118-B542-4629-A60B-B973168EEA81', '/Services', 'ClientManagement.asmx', 'ListClients', NULL,0,1 UNION ALL 
        SELECT 1, '24E46F04-9A80-4E38-A363-92A1FFE843DB', '/AdministrationWS', 'Authentication.asmx', 'Login', NULL,0,1 
 
        SET IDENTITY_INSERT TRefWebService OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '752BE3E6-F54C-4BE2-BF01-AACEDF075BF5', 
         'Initial load (3 total rows, file 1 of 1) for table TRefWebService',
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
