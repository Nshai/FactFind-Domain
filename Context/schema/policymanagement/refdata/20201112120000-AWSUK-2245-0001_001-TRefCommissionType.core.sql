 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefCommissionType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'E980B6EE-4B9E-40E6-B0C7-38D6358789C8'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefCommissionType ON; 
 
        INSERT INTO TRefCommissionType([RefCommissionTypeId], [CommissionTypeName], [RefLicenseTypeId], [OrigoRef], [InitialCommissionFg], [RecurringCommissionFg], [RetireFg], [Extensible], [ConcurrencyId])
        SELECT 1, 'indemnity',1, NULL,1,0,0,NULL,2 UNION ALL 
        SELECT 2, 'non-indemnity',1, NULL,1,0,0,NULL,2 UNION ALL 
        SELECT 3, 'single premium',1, NULL,1,0,0,NULL,2 UNION ALL 
        SELECT 4, 'level',1, 'CommissionType',0,1,0,NULL,2 UNION ALL 
        SELECT 5, 'renewal',1, 'CommissionType',0,1,0,NULL,2 UNION ALL 
        SELECT 6, 'fund based',1, 'CommissionType',0,1,0,NULL,2 UNION ALL 
        SELECT 7, 'Mortgage Proc Fee',2, NULL,1,0,0,NULL,1 
 
        SET IDENTITY_INSERT TRefCommissionType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'E980B6EE-4B9E-40E6-B0C7-38D6358789C8', 
         'Initial load (7 total rows, file 1 of 1) for table TRefCommissionType',
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
-- #Rows Exported: 7
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
