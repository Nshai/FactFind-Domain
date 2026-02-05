 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefPlanValueType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '82AF3C0B-5067-4E4A-B190-A01FEF637BC0'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPlanValueType ON; 
 
        INSERT INTO TRefPlanValueType([RefPlanValueTypeId], [RefPlanValueType], [RetireFg], [ServiceType], [ServiceTypeDescription], [ConcurrencyId])
        SELECT 7, 'Hidden - Bulk Valuation',1,64, 'Value used to hide the provider from the Adviser Schedule Setup [BULKHIDDEN]',1 UNION ALL 
        SELECT 6, 'Manual - Bulk Valuation',1,32, 'Manual Bulk [BULKMANUAL]',1 UNION ALL 
        SELECT 5, 'Electronic - Scheduled Request',0,8, 'Scheduled realtime [REALTIMEBATCH]',2 UNION ALL 
        SELECT 4, 'Underlying Fund Values',0,2, 'Underlying fund [MANUALUNDERLYINGFUND]',2 UNION ALL 
        SELECT 2, 'Electronic - Bulk Valuation',1,16, 'Provider Bulk - [BULKPROVIDER]',2 UNION ALL 
        SELECT 1, 'Manual',0,1, 'Manual [MANUAL]',2 UNION ALL 
        SELECT 8, 'Manual - Bulk Valuation Template',1,128, 'Bulk Manual Template [BULKMANUALTEMPLATE]',1 
 
        SET IDENTITY_INSERT TRefPlanValueType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '82AF3C0B-5067-4E4A-B190-A01FEF637BC0', 
         'Initial load (7 total rows, file 1 of 1) for table TRefPlanValueType',
         null, 
         getutcdate() )
 
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
-- #Rows Exported: 7
-- Created by Yury Zakharov, May 13 2021
-----------------------------------------------------------------------------
