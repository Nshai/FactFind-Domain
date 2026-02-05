 
-----------------------------------------------------------------------------
-- Table: CRM.TRefFFContactType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '2F749F62-2CB0-46D3-837E-7A509A101120'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefFFContactType ON; 
 
        INSERT INTO TRefFFContactType([RefFFContactTypeId], [ContactTypeName], [ValidationExpression], [ArchiveFG], [ConcurrencyId])
        SELECT 1, 'Telephone', '^\+?(\(?[0-9]{2}\)?)?\s?(\([0-9]*\))?\s?[0-9 ]*$',0,1 UNION ALL 
        SELECT 2, 'Business', '^\+?(\(?[0-9]{2}\)?)?\s?(\([0-9]*\))?\s?[0-9 ]*$',0,1 UNION ALL 
        SELECT 3, 'Fax', '^\+?(\(?[0-9]{2}\)?)?\s?(\([0-9]*\))?\s?[0-9 ]*$',0,1 UNION ALL 
        SELECT 4, 'Mobile', '^\+?(\(?[0-9]{2}\)?)?\s?(\([0-9]*\))?\s?[0-9 ]*$',0,1 UNION ALL 
        SELECT 5, 'E-Mail', '^[\w-]+(?:\.[\w-]+)*@(?:[\w-]+\.)+[a-zA-Z]{2,7}$',0,1 UNION ALL 
        SELECT 6, 'Web Site', '^[A-Za-z0-9\:\/]*[\.][A-Za-z0-9\-]*[\.][A-Za-z0-9\./]*$',0,1 
 
        SET IDENTITY_INSERT TRefFFContactType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '2F749F62-2CB0-46D3-837E-7A509A101120', 
         'Initial load (6 total rows, file 1 of 1) for table TRefFFContactType',
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
-- #Rows Exported: 6
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
