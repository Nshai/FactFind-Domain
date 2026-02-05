 
-----------------------------------------------------------------------------
-- Table: CRM.TRefCRMContactStatus
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '97A49AC2-681D-44BF-B0A6-74B1B147CEF0'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefCRMContactStatus ON; 
 
        INSERT INTO TRefCRMContactStatus([RefCRMContactStatusId], [StatusName], [OrderNo], [InternalFG], [ConcurrencyId])
        SELECT 3, 'Related Party',3,0,2 UNION ALL 
        SELECT 2, 'Prospect',2,0,2 UNION ALL 
        SELECT 1, 'Client',1,0,2 
 
        SET IDENTITY_INSERT TRefCRMContactStatus OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '97A49AC2-681D-44BF-B0A6-74B1B147CEF0', 
         'Initial load (3 total rows, file 1 of 1) for table TRefCRMContactStatus',
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
-- #Rows Exported: 3
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
