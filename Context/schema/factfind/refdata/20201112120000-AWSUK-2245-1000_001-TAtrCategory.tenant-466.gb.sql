 
-----------------------------------------------------------------------------
-- Table: FactFind.TAtrCategory
--    Join: 
--   Where: WHERE TenantId=466
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'F75107AC-2B15-4521-83B7-20E99D0B1DE4'
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
        SET IDENTITY_INSERT TAtrCategory ON; 
 
        INSERT INTO TAtrCategory([AtrCategoryId], [Guid], [TenantId], [TenantGuid], [Name], [IsArchived], [ConcurrencyId])
        SELECT 319,'A44035EF-F671-431F-ABFC-E0C6853FECA7',466,'9D7C163A-1166-45E9-B9E7-712388CE038E', 'Default',0,1 UNION ALL 
        SELECT 4992,'9FD192D3-043B-4C2F-91B6-A70700C3B940',466,'9D7C163A-1166-45E9-B9E7-712388CE038E', 'Test',1,1 
 
        SET IDENTITY_INSERT TAtrCategory OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'F75107AC-2B15-4521-83B7-20E99D0B1DE4', 
         'Initial load (2 total rows, file 1 of 1) for table TAtrCategory',
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
-- #Rows Exported: 2
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
