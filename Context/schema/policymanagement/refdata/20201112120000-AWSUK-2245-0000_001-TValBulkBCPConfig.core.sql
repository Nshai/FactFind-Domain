 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValBulkBCPConfig
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '6271E2B5-7E62-40A1-9C2C-D6DC6EC86D75'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TValBulkBCPConfig ON; 
 
        INSERT INTO TValBulkBCPConfig([BCPConfigId], [RefProdProviderId], [MappingFile], [ColumnCount], [HeaderRowsToStrip], [FooterRowsToStrip], [UnEvenRowsToStrip], [ConcurrencyId])
        SELECT 1,558, '\TValBulkCofundMapping.fmt',83,0,0,2,2 UNION ALL 
        SELECT 2,567, '\TValBulkFidelityMapping.fmt',34,0,0,0,3 UNION ALL 
        SELECT 3,1405, '\TValBulkNucleusMapping.fmt',13,0,0,0,1 UNION ALL 
        SELECT 4,1543, '\TValBulkCitiQuilterMapping.fmt',30,0,0,0,1 UNION ALL 
        SELECT 5,1555, '\TValBulkAscentricMapping.fmt',26,0,0,0,1 UNION ALL 
        SELECT 6,1814, '\TValBulkNoviaMapping.fmt',19,0,0,0,1 UNION ALL 
        SELECT 8,1019, '\TValBulkRJamesMapping.fmt',23,0,0,0,1 UNION ALL 
        SELECT 9,878, '\TValBulkBMacDonaldMapping.fmt',54,1,0,0,3 UNION ALL 
        SELECT 10,1145, '\TValBulkMargettsMapping.fmt',13,0,0,0,1 UNION ALL 
        SELECT 11,1509, '\TValBulkParmenionMapping.fmt',15,0,0,0,1 UNION ALL 
        SELECT 12,2438, '\TValBulkAvivaMapping.fmt',15,0,0,0,2 UNION ALL 
        SELECT 13,2247, '\TValBulkWealthtimeMapping.fmt',16,1,0,0,1 UNION ALL 
        SELECT 14,302, '\TValBulkRowanDMapping.fmt',16,1,0,0,1 UNION ALL 
        SELECT 15,2313, '\TValBulkSignatureMapping.fmt',16,1,0,0,1 UNION ALL 
        SELECT 16,183, '\TValBulkJamesHayMapping.fmt',19,1,0,0,1 UNION ALL 
        SELECT 17,2288, '\TValBulkInvestecMapping.fmt',11,0,0,0,1 UNION ALL 
        SELECT 18,1377, '\TValBulkThesisMapping.fmt',22,1,0,0,1 UNION ALL 
        SELECT 19,2215, '\TValBulkCloseMapping.fmt',13,0,0,0,1 UNION ALL 
        SELECT 20,901, '\TValBulkRedmayneMapping.fmt',23,0,0,0,1 UNION ALL 
        SELECT 21,556, '\TValBulkAJBellMapping.fmt',14,0,0,0,1 UNION ALL 
        SELECT 22,2572, '\TValBulkManualTemplateMapping.fmt',13,1,0,0,2 
 
        SET IDENTITY_INSERT TValBulkBCPConfig OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '6271E2B5-7E62-40A1-9C2C-D6DC6EC86D75', 
         'Initial load (21 total rows, file 1 of 1) for table TValBulkBCPConfig',
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
-- #Rows Exported: 21
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
