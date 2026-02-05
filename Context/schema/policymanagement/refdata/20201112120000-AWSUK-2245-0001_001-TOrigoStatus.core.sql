 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TOrigoStatus
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '48BB3AB2-38FC-43AB-903D-18FCEAC094F9'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TOrigoStatus ON; 
 
        INSERT INTO TOrigoStatus([OrigoStatusId], [OrigoRef], [RetiredFg], [ConcurrencyId])
        SELECT 19, 'Withdrawn',0,1 UNION ALL 
        SELECT 18, 'Surrendered',0,1 UNION ALL 
        SELECT 17, 'Rejected',0,1 UNION ALL 
        SELECT 16, 'Registered',0,1 UNION ALL 
        SELECT 15, 'Policy Issued',0,1 UNION ALL 
        SELECT 14, 'Paid Up',0,1 UNION ALL 
        SELECT 13, 'NTU',0,1 UNION ALL 
        SELECT 12, 'NPW',0,1 UNION ALL 
        SELECT 11, 'Matured',0,1 UNION ALL 
        SELECT 10, 'Lapsed',0,1 UNION ALL 
        SELECT 9, 'Invalid',0,1 UNION ALL 
        SELECT 8, 'In Force',0,1 UNION ALL 
        SELECT 7, 'Expired',0,1 UNION ALL 
        SELECT 6, 'Deferred',0,1 UNION ALL 
        SELECT 5, 'Declined',0,1 UNION ALL 
        SELECT 4, 'Cancelled',0,1 UNION ALL 
        SELECT 3, 'Additional Data Required',0,1 UNION ALL 
        SELECT 2, 'Accepted (Standard)',0,1 UNION ALL 
        SELECT 1, 'Accepted (Rated)',0,1 
 
        SET IDENTITY_INSERT TOrigoStatus OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '48BB3AB2-38FC-43AB-903D-18FCEAC094F9', 
         'Initial load (19 total rows, file 1 of 1) for table TOrigoStatus',
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
-- #Rows Exported: 19
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
