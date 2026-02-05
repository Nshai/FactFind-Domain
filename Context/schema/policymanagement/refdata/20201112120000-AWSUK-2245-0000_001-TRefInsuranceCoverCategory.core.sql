 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefInsuranceCoverCategory
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'F74553DF-F009-4070-B9AD-6B5C55CB2A18'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefInsuranceCoverCategory ON; 
 
        INSERT INTO TRefInsuranceCoverCategory([RefInsuranceCoverCategoryId], [Name], [ConcurrencyId])
        SELECT 1, 'Buildings',1 UNION ALL 
        SELECT 2, 'Contents',1 UNION ALL 
        SELECT 3, 'Travel',1 UNION ALL 
        SELECT 4, 'Private Motor',1 UNION ALL 
        SELECT 5, 'PaymentProtection',1 UNION ALL 
        SELECT 6, 'Health',1 UNION ALL 
        SELECT 7, 'Professional Indemnity',1 UNION ALL 
        SELECT 8, 'Commercial Motor',1 UNION ALL 
        SELECT 9, 'Liability',1 
 
        SET IDENTITY_INSERT TRefInsuranceCoverCategory OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'F74553DF-F009-4070-B9AD-6B5C55CB2A18', 
         'Initial load (9 total rows, file 1 of 1) for table TRefInsuranceCoverCategory',
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
-- #Rows Exported: 9
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
