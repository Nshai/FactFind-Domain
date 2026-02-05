 
-----------------------------------------------------------------------------
-- Table: FactFind.TDocumentDisclosureType
--    Join: 
--   Where: WHERE IndigoClientId=0
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '41FA4BE3-FA65-403E-A41B-6E3041824EEB'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TDocumentDisclosureType ON; 
 
        INSERT INTO TDocumentDisclosureType([DocumentDisclosureTypeId], [ConcurrencyId], [Name], [IsArchived], [IndigoClientId])
        SELECT 1,1, 'Disclosure Document',0,0 UNION ALL 
        SELECT 2,1, 'Service and Cost Disclosure Document',0,0 UNION ALL 
        SELECT 3,1, 'Combined Initial Disclosure Document',0,0 UNION ALL 
        SELECT 4,1, 'Combined Disclosure Documents',0,0 UNION ALL 
        SELECT 5,1, 'Key Facts About Services',0,0 UNION ALL 
        SELECT 6,1, 'Key Facts About Cost of Services',0,0 UNION ALL 
        SELECT 7,1, 'Terms of Business',0,0 UNION ALL 
        SELECT 8,1, 'Terms for Refund of Fees',0,0 
 
        SET IDENTITY_INSERT TDocumentDisclosureType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '41FA4BE3-FA65-403E-A41B-6E3041824EEB', 
         'Initial load (8 total rows, file 1 of 1) for table TDocumentDisclosureType',
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
