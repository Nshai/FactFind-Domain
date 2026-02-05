 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefInterviewType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '13C02E24-D0B6-4678-8531-B22559F8F2BE'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefInterviewType ON; 
 
        INSERT INTO TRefInterviewType([RefInterviewTypeId], [InterviewType], [ConcurrencyId])
        SELECT 1, 'Face to Face',1 UNION ALL 
        SELECT 2, 'Telephone',1 UNION ALL 
        SELECT 3, 'Face to Face - Recorded',1 UNION ALL 
        SELECT 4, 'Telephone - Recorded',1 UNION ALL 
        SELECT 5, 'Video Call',1 UNION ALL 
        SELECT 6, 'Video Call - Recorded',1 UNION ALL 
        SELECT 7, 'Electronic',1 UNION ALL 
        SELECT 8, 'Electronic - Recorded',1 
 
        SET IDENTITY_INSERT TRefInterviewType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '13C02E24-D0B6-4678-8531-B22559F8F2BE', 
         'Initial load (8 total rows, file 1 of 1) for table TRefInterviewType',
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
-- #Rows Exported: 8
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
