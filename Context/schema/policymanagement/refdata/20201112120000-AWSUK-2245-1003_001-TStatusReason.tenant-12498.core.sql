 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TStatusReason
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '9BA3274B-5026-470D-8BB4-D3885E358C45'
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
        SET IDENTITY_INSERT TStatusReason ON; 
 
        INSERT INTO TStatusReason([StatusReasonId], [Name], [StatusId], [OrigoStatusId], [IntelligentOfficeStatusType], [IndigoClientId], [ConcurrencyId], [RefLicenceTypeId], [IsArchived])
        SELECT 87258, 'Adverse U/W Conditions',40213,NULL, 'Adverse U/W Conditions',12498,1,1,0 UNION ALL 
        SELECT 87259, 'Cancelled from Inception (CFI)',40213,NULL, 'Cancelled from Inception (CFI)',12498,1,1,0 UNION ALL 
        SELECT 87260, 'Mortgage Fall Through (NPW)',40213,NULL, 'Mortgage Fall Through (NPW)',12498,1,1,0 UNION ALL 
        SELECT 87261, 'Multiple Apps for Underwriting (NPW)',40213,NULL, 'Multiple Apps for Underwriting (NPW)',12498,1,1,0 UNION ALL 
        SELECT 87262, 'Unclassified',40213,NULL, 'Unclassified',12498,1,1,0 UNION ALL 
        SELECT 87263, 'Matured',40214,NULL, 'Matured',12498,1,1,0 UNION ALL 
        SELECT 87264, 'Expired',40213,NULL, 'Expired',12498,1,1,0 UNION ALL 
        SELECT 87265, 'Declined U/W',40213,NULL, 'Declined U/W',12498,1,1,0 UNION ALL 
        SELECT 87266, 'Transferred',40214,NULL, 'Transferred',12498,1,1,0 UNION ALL 
        SELECT 87267, 'Adverse U/W Conditions',40213,NULL, 'Adverse U/W Conditions',12498,1,2,0 UNION ALL 
        SELECT 87268, 'Declined U/W',40213,NULL, 'Declined U/W',12498,1,2,0 UNION ALL 
        SELECT 87269, 'Cancelled from Inception (CFI)',40213,NULL, 'Cancelled from Inception (CFI)',12498,1,2,0 UNION ALL 
        SELECT 87270, 'Expired',40213,NULL, 'Expired',12498,1,2,0 UNION ALL 
        SELECT 87271, 'Mortgage Fall Through (NPW)',40213,NULL, 'Mortgage Fall Through (NPW)',12498,1,2,0 UNION ALL 
        SELECT 87272, 'Matured',40214,NULL, 'Matured',12498,1,2,0 UNION ALL 
        SELECT 87273, 'Lapsed',40214,NULL, 'Lapsed',12498,1,2,0 UNION ALL 
        SELECT 87274, 'Cancelled By Client',40214,NULL, 'Cancelled By Client',12498,1,2,0 UNION ALL 
        SELECT 87275, 'Replaced',40214,NULL, 'Replaced',12498,1,2,0 UNION ALL 
        SELECT 87276, '14 Day Cancellation',40214,NULL, '14 Day Cancellation',12498,1,2,0 UNION ALL 
        SELECT 87277, 'Surrendered',40214,NULL, 'Surrendered',12498,1,1,0 UNION ALL 
        SELECT 87278, 'Lapsed',40214,NULL, 'Lapsed',12498,1,1,0 UNION ALL 
        SELECT 87279, 'Cancelled By Client',40214,NULL, 'Cancelled By Client',12498,1,1,0 UNION ALL 
        SELECT 87280, 'Replaced',40214,NULL, 'Replaced',12498,1,1,0 UNION ALL 
        SELECT 87281, 'Sold',40214,NULL, 'Sold',12498,1,1,0 UNION ALL 
        SELECT 87282, '14 Day Cancellation',40214,NULL, '14 Day Cancellation',12498,1,1,0 UNION ALL 
        SELECT 87283, 'Paid Up',40214,NULL, 'Paid Up',12498,1,1,0 
 
        SET IDENTITY_INSERT TStatusReason OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '9BA3274B-5026-470D-8BB4-D3885E358C45', 
         'Initial load (26 total rows, file 1 of 1) for table TStatusReason',
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
-- #Rows Exported: 26
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
