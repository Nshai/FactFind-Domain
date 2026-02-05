 
-----------------------------------------------------------------------------
-- Table: CRM.TRefPFPSecureMessageStatus
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '5BCA589B-C8A2-4790-BD5F-9F503D47DC0F'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPFPSecureMessageStatus ON; 
 
        INSERT INTO TRefPFPSecureMessageStatus([RefPFPSecureMessageStatusId], [StatusName], [ConcurrencyId])
        SELECT 1, 'Received',1 UNION ALL 
        SELECT 2, 'Draft',1 UNION ALL 
        SELECT 3, 'Sent',1 
 
        SET IDENTITY_INSERT TRefPFPSecureMessageStatus OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '5BCA589B-C8A2-4790-BD5F-9F503D47DC0F', 
         'Initial load (3 total rows, file 1 of 1) for table TRefPFPSecureMessageStatus',
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
