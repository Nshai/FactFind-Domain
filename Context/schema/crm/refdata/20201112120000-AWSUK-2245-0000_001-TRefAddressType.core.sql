 
-----------------------------------------------------------------------------
-- Table: CRM.TRefAddressType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'C437DD22-5ACB-4E84-ABA4-4F34E07F0C4C'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefAddressType ON; 
 
        INSERT INTO TRefAddressType([RefAddressTypeId], [AddressTypeName], [ConcurrencyId])
        SELECT 1, 'Home',1 UNION ALL 
        SELECT 2, 'Business',1 UNION ALL 
        SELECT 3, 'Other',1 UNION ALL 
        SELECT 4, 'Registered',1 UNION ALL 
        SELECT 5, 'Correspondence',1 
 
        SET IDENTITY_INSERT TRefAddressType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'C437DD22-5ACB-4E84-ABA4-4F34E07F0C4C', 
         'Initial load (5 total rows, file 1 of 1) for table TRefAddressType',
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
-- #Rows Exported: 5
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
