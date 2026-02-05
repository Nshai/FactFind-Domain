 
-----------------------------------------------------------------------------
-- Table: CRM.TRefAccountAccess
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '1F21FC86-670A-4C2A-97BC-428F64319779'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefAccountAccess ON; 
 
        INSERT INTO TRefAccountAccess([RefAccountAccessId], [AccessTypeName], [ConcurrencyId])
        SELECT 1, 'Owner and Creator Only',1 UNION ALL 
        SELECT 2, 'Owners Group Only',1 UNION ALL 
        SELECT 3, 'Owners Group and Subordinate Groups Only',1 UNION ALL 
        SELECT 4, 'Entire Organisation',1 
 
        SET IDENTITY_INSERT TRefAccountAccess OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '1F21FC86-670A-4C2A-97BC-428F64319779', 
         'Initial load (4 total rows, file 1 of 1) for table TRefAccountAccess',
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
