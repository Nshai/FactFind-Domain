 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TAdviseFeeChargingType
--    Join: 
--   Where: WHERE TenantId=466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '000C14D7-FD2B-4BFD-81EC-04761BE395BC'
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
        SET IDENTITY_INSERT TAdviseFeeChargingType ON; 
 
        INSERT INTO TAdviseFeeChargingType([AdviseFeeChargingTypeId], [RefAdviseFeeChargingTypeId], [TenantId], [IsArchived], [ConcurrencyId], [GroupId])
        SELECT 3663,1,466,0,0,NULL UNION ALL 
        SELECT 5000,2,466,0,0,NULL UNION ALL 
        SELECT 6182,3,466,0,0,NULL UNION ALL 
        SELECT 7426,4,466,0,0,NULL UNION ALL 
        SELECT 8920,5,466,0,0,NULL UNION ALL 
        SELECT 10292,6,466,0,0,NULL UNION ALL 
        SELECT 12043,7,466,0,0,NULL UNION ALL 
        SELECT 13898,8,466,0,0,NULL UNION ALL 
        SELECT 15833,9,466,0,0,NULL UNION ALL 
        SELECT 17768,10,466,0,0,NULL 
 
        SET IDENTITY_INSERT TAdviseFeeChargingType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '000C14D7-FD2B-4BFD-81EC-04761BE395BC', 
         'Initial load (10 total rows, file 1 of 1) for table TAdviseFeeChargingType',
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
-- #Rows Exported: 10
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
