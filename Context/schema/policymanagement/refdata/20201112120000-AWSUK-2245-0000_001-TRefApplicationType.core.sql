 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefApplicationType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '28A0B4ED-0E6A-414A-AC2B-28257C355BF7'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefApplicationType ON; 
 
        INSERT INTO TRefApplicationType([RefApplicationTypeId], [ApplicationTypeName], [IsArchived], [ConcurrencyId])
        SELECT 1, 'Quotation Portal',0,1 UNION ALL 
        SELECT 2, 'WRAP Valuation',0,1 UNION ALL 
        SELECT 3, 'Mortgage Sourcing',0,1 UNION ALL 
        SELECT 4, 'Email',0,1 UNION ALL 
        SELECT 5, 'Mortgage Application',0,1 UNION ALL 
        SELECT 6, 'Applications',0,1 UNION ALL 
        SELECT 7, 'SMS',0,1 UNION ALL 
        SELECT 8, 'Address Lookup',0,1 UNION ALL 
        SELECT 10, 'Platforms',0,1 UNION ALL 
        SELECT 11, 'Client Lookup',0,1 UNION ALL 
        SELECT 12, 'Batch Feed',0,1 UNION ALL 
        SELECT 13, 'CRM Sync Portal',0,1 UNION ALL 
        SELECT 14, 'Fund Analysis',0,1 UNION ALL 
        SELECT 15, 'Income Statement',0,1 
 
        SET IDENTITY_INSERT TRefApplicationType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '28A0B4ED-0E6A-414A-AC2B-28257C355BF7', 
         'Initial load (14 total rows, file 1 of 1) for table TRefApplicationType',
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
-- #Rows Exported: 14
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
