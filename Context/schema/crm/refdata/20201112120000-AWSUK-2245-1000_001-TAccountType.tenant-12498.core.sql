 
-----------------------------------------------------------------------------
-- Table: CRM.TAccountType
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '46CF0431-C04E-47DF-B73A-01F6694A9520'
     AND TenantId = 12498
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TAccountType ON; 
 
        INSERT INTO TAccountType([AccountTypeId], [AccountTypeName], [IsForCorporate], [IsForIndividual], [IsNotModifiable], [IsArchived], [IndigoClientId], [ConcurrencyId])
        SELECT 30887, 'Provider',1,0,1,0,12498,1 UNION ALL 
        SELECT 30888, 'Supplier',1,0,0,0,12498,1 UNION ALL 
        SELECT 30889, 'Partner',1,1,0,0,12498,1 UNION ALL 
        SELECT 30890, 'Press',1,0,0,0,12498,1 UNION ALL 
        SELECT 30891, 'Utility',1,1,0,0,12498,1 UNION ALL 
        SELECT 30892, 'Telephone',1,1,0,0,12498,1 UNION ALL 
        SELECT 30893, 'Estate Agents',1,1,0,0,12498,1 UNION ALL 
        SELECT 30894, 'Friends',0,1,0,0,12498,1 UNION ALL 
        SELECT 30895, 'Events Co-ordinator',1,1,0,0,12498,1 
 
        SET IDENTITY_INSERT TAccountType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '46CF0431-C04E-47DF-B73A-01F6694A9520', 
         'Initial load (9 total rows, file 1 of 1) for table TAccountType',
         12498, 
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
-- #Rows Exported: 9
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
