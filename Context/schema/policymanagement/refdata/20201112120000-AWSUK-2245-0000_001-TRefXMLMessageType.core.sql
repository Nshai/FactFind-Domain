 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefXMLMessageType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '05A6C461-E27D-454B-9DDB-C4E82E98683D'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefXMLMessageType ON; 
 
        INSERT INTO TRefXMLMessageType([RefXMLMessageTypeId], [Identifier], [IsArchived], [ConcurrencyId])
        SELECT 1, 'Quote Request',0,1 UNION ALL 
        SELECT 2, 'Quote Response',0,1 UNION ALL 
        SELECT 3, 'Quote Details Request',0,1 UNION ALL 
        SELECT 4, 'Quote Details Response',0,1 UNION ALL 
        SELECT 5, 'Extranet Linking Message',0,1 UNION ALL 
        SELECT 6, 'RPA Quote Message',0,1 UNION ALL 
        SELECT 7, 'RPA Quote Response',0,1 UNION ALL 
        SELECT 8, 'RPA Print Message',0,1 UNION ALL 
        SELECT 9, 'RPA Print Response',0,1 UNION ALL 
        SELECT 10, 'Status Message',0,1 UNION ALL 
        SELECT 11, 'Status Acknowledgement',0,1 UNION ALL 
        SELECT 12, 'Ts And Cs Request',0,1 UNION ALL 
        SELECT 13, 'Ts And Cs Response',0,1 UNION ALL 
        SELECT 14, 'Fee Request',0,1 UNION ALL 
        SELECT 15, 'Fee Response',0,1 UNION ALL 
        SELECT 16, 'KFI Request',0,1 UNION ALL 
        SELECT 17, 'KFI Response',0,1 
 
        SET IDENTITY_INSERT TRefXMLMessageType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '05A6C461-E27D-454B-9DDB-C4E82E98683D', 
         'Initial load (17 total rows, file 1 of 1) for table TRefXMLMessageType',
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
-- #Rows Exported: 17
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
