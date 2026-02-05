 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefFundAttribute
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '5ADEFCD4-3B6E-4B1C-967C-5E1DD7AA42B5'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefFundAttribute ON; 
 
        INSERT INTO TRefFundAttribute([RefFundAttributeId], [AttributeName], [AttributeCode], [ConcurrencyId], [AttributeBit])
        SELECT 1, 'Protected Rights', 'PR',1,1 UNION ALL 
        SELECT 2, 'Non Protected Rights', 'NPR',1,2 UNION ALL 
        SELECT 3, 'Initial', 'INI',1,4 UNION ALL 
        SELECT 4, 'Accumulation', 'ACC',1,8 UNION ALL 
        SELECT 5, 'Income', 'INC',1,16 UNION ALL 
        SELECT 6, 'Pre 1997', 'PRE1997',1,32 UNION ALL 
        SELECT 7, 'Post 1997', 'POST1997',1,64 UNION ALL 
        SELECT 8, 'Non-Protected Rights', 'N-PR',1,128 
 
        SET IDENTITY_INSERT TRefFundAttribute OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '5ADEFCD4-3B6E-4B1C-967C-5E1DD7AA42B5', 
         'Initial load (8 total rows, file 1 of 1) for table TRefFundAttribute',
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
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
