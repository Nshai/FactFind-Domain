 
-----------------------------------------------------------------------------
-- Table: CRM.TRefContactType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '00713FE6-D857-4279-A256-68B0811C2739'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefContactType ON; 
 
        INSERT INTO TRefContactType([RefContactTypeId], [ContactTypeName], [ArchiveFG], [Extensible], [ConcurrencyId])
        SELECT 20, 'Web Site',0,NULL,1 UNION ALL 
        SELECT 19, 'Home',0,NULL,1 UNION ALL 
        SELECT 18, 'Telex',0,NULL,1 UNION ALL 
        SELECT 17, 'Radio',0,NULL,1 UNION ALL 
        SELECT 16, 'Primary',0,NULL,1 UNION ALL 
        SELECT 15, 'Pager',0,NULL,1 UNION ALL 
        SELECT 14, 'Other Fax',0,NULL,1 UNION ALL 
        SELECT 13, 'Other',0,NULL,1 UNION ALL 
        SELECT 12, 'Mobile',0,NULL,1 UNION ALL 
        SELECT 11, 'ISDN',0,NULL,1 UNION ALL 
        SELECT 10, 'Alternative Home',0,NULL,1 UNION ALL 
        SELECT 9, 'Car',0,NULL,1 UNION ALL 
        SELECT 8, 'Callback',0,NULL,1 UNION ALL 
        SELECT 7, 'Business Fax',0,NULL,1 UNION ALL 
        SELECT 6, 'Business2',0,NULL,1 UNION ALL 
        SELECT 5, 'Business',0,NULL,1 UNION ALL 
        SELECT 4, 'Assistant',0,NULL,1 UNION ALL 
        SELECT 3, 'E-Mail',0,NULL,2 UNION ALL 
        SELECT 2, 'Fax',0,NULL,1 UNION ALL 
        SELECT 1, 'Telephone',0,NULL,1 UNION ALL 
        SELECT 21, 'Social Media',0,NULL,1 UNION ALL 
        SELECT 22, 'Skype',0,NULL,1 UNION ALL 
        SELECT 23, 'Lync',1,NULL,1 
 
        SET IDENTITY_INSERT TRefContactType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '00713FE6-D857-4279-A256-68B0811C2739', 
         'Initial load (23 total rows, file 1 of 1) for table TRefContactType',
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
-- #Rows Exported: 23
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
