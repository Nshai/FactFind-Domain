 
-----------------------------------------------------------------------------
-- Table: Administration.TRefEmailAssociationType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '9ED90B59-56F8-4693-9A74-78F5DE650BA4'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefEmailAssociationType ON; 
 
        INSERT INTO TRefEmailAssociationType([RefEmailAssociationTypeId], [AssociationTypeName], [ConcurrencyId])
        SELECT 1, 'Clients',1 UNION ALL 
        SELECT 2, 'Leads',1 UNION ALL 
        SELECT 3, 'Accounts',1 UNION ALL 
        SELECT 4, 'Advisers',1 
 
        SET IDENTITY_INSERT TRefEmailAssociationType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '9ED90B59-56F8-4693-9A74-78F5DE650BA4', 
         'Initial load (4 total rows, file 1 of 1) for table TRefEmailAssociationType',
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
