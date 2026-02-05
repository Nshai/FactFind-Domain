 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TStatusReason
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '9BA3274B-5026-470D-8BB4-D3885E358C45'
     AND TenantId = 466
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TStatusReason ON; 
 
        INSERT INTO TStatusReason([StatusReasonId], [Name], [StatusId], [OrigoStatusId], [IntelligentOfficeStatusType], [IndigoClientId], [ConcurrencyId], [RefLicenceTypeId], [IsArchived])
        SELECT 5727, 'Adverse U/W Conditions',3873,NULL, 'Adverse U/W Conditions',466,1,1,0 UNION ALL 
        SELECT 5728, 'Declined U/W',3873,NULL, 'Declined U/W',466,1,1,0 UNION ALL 
        SELECT 5729, 'Cancelled from Inception (CFI)',3873,NULL, 'Cancelled from Inception (CFI)',466,1,1,0 UNION ALL 
        SELECT 5730, 'Expired',3873,NULL, 'Expired',466,1,1,0 UNION ALL 
        SELECT 5731, 'Mortgage Fall Through (NPW)',3873,NULL, 'Mortgage Fall Through (NPW)',466,1,1,0 UNION ALL 
        SELECT 5732, 'Multiple Apps for Underwriting (NPW)',3873,NULL, 'Multiple Apps for Underwriting (NPW)',466,1,1,0 UNION ALL 
        SELECT 5733, 'Unclassified',3873,NULL, 'Unclassified',466,1,1,0 UNION ALL 
        SELECT 5734, 'Matured',3874,NULL, 'Matured',466,1,1,0 UNION ALL 
        SELECT 5735, 'Surrendered',3874,NULL, 'Surrendered',466,1,1,0 UNION ALL 
        SELECT 5736, 'Lapsed',3874,NULL, 'Lapsed',466,1,1,0 UNION ALL 
        SELECT 5737, 'Cancelled By Client',3874,NULL, 'Cancelled By Client',466,1,1,0 UNION ALL 
        SELECT 5738, 'Transferred',3874,NULL, 'Transferred',466,1,1,0 UNION ALL 
        SELECT 5739, 'Replaced',3874,NULL, 'Replaced',466,1,1,0 UNION ALL 
        SELECT 5740, 'Sold',3874,NULL, 'Sold',466,1,1,0 UNION ALL 
        SELECT 5741, '14 Day Cancellation',3874,NULL, '14 Day Cancellation',466,1,1,0 UNION ALL 
        SELECT 5742, 'Paid Up',3874,NULL, 'Paid Up',466,1,1,1 UNION ALL 
        SELECT 33520, 'Adverse U/W Conditions',3873,NULL, 'Adverse U/W Conditions',466,1,2,0 UNION ALL 
        SELECT 33521, 'Declined U/W',3873,NULL, 'Declined U/W',466,1,2,0 UNION ALL 
        SELECT 33522, 'Cancelled from Inception (CFI)',3873,NULL, 'Cancelled from Inception (CFI)',466,1,2,0 UNION ALL 
        SELECT 33523, 'Expired',3873,NULL, 'Expired',466,1,2,0 UNION ALL 
        SELECT 33524, 'Mortgage Fall Through (NPW)',3873,NULL, 'Mortgage Fall Through (NPW)',466,1,2,0 UNION ALL 
        SELECT 33525, 'Matured',3874,NULL, 'Matured',466,1,2,0 UNION ALL 
        SELECT 33526, 'Lapsed',3874,NULL, 'Lapsed',466,1,2,0 UNION ALL 
        SELECT 33527, 'Cancelled By Client',3874,NULL, 'Cancelled By Client',466,1,2,0 UNION ALL 
        SELECT 33528, 'Replaced',3874,NULL, 'Replaced',466,1,2,0 UNION ALL 
        SELECT 33529, '14 Day Cancellation',3874,NULL, '14 Day Cancellation',466,1,2,0 
 
        SET IDENTITY_INSERT TStatusReason OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '9BA3274B-5026-470D-8BB4-D3885E358C45', 
         'Initial load (26 total rows, file 1 of 1) for table TStatusReason',
         466, 
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
-- #Rows Exported: 26
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
