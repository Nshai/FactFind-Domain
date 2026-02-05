 
-----------------------------------------------------------------------------
-- Table: CRM.TRefSystemEvent
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'CC61C702-B9DB-46A8-A6CB-AA198251AD4D'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefSystemEvent ON; 
 
        INSERT INTO TRefSystemEvent([RefSystemEventId], [Identifier], [ConcurrencyId])
        SELECT 1, 'Appointment',1 UNION ALL 
        SELECT 2, 'Assessment',1 UNION ALL 
        SELECT 3, '1st Appointment',0 UNION ALL 
        SELECT 4, '2nd Appointment',0 UNION ALL 
        SELECT 5, 'Pre Appointment Call',0 UNION ALL 
        SELECT 6, 'Report Writing',0 UNION ALL 
        SELECT 7, '1st Interview',0 UNION ALL 
        SELECT 8, '2nd Interview',0 UNION ALL 
        SELECT 9, 'Date ToB Given',1 UNION ALL 
        SELECT 10, 'Date Fact Find Completed',1 UNION ALL 
        SELECT 11, 'Date Declaration Signed',1 UNION ALL 
        SELECT 12, 'Date ID and Money Laundering Checked',1 UNION ALL 
        SELECT 13, 'Review Diary Date',1 UNION ALL 
        SELECT 14, 'Date Client Agreement / SCDD Given',1 UNION ALL 
        SELECT 15, 'Review',0 
 
        SET IDENTITY_INSERT TRefSystemEvent OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'CC61C702-B9DB-46A8-A6CB-AA198251AD4D', 
         'Initial load (15 total rows, file 1 of 1) for table TRefSystemEvent',
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
-- #Rows Exported: 15
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
