 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefFeeType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '52407F93-349B-4BE7-AD20-5DB653F48635'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefFeeType ON; 
 
        INSERT INTO TRefFeeType([RefFeeTypeId], [FeeTypeName], [RefVATId], [FeeFg], [RetainerFg], [Extensible], [ConcurrencyId])
        SELECT 1, 'Standard',1,1,0,NULL,1 UNION ALL 
        SELECT 2, 'Per Hour Billing',1,0,0,NULL,1 UNION ALL 
        SELECT 3, '% Funding Under Management',1,0,0,NULL,1 UNION ALL 
        SELECT 4, 'Standard',1,0,1,NULL,1 
 
        SET IDENTITY_INSERT TRefFeeType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '52407F93-349B-4BE7-AD20-5DB653F48635', 
         'Initial load (4 total rows, file 1 of 1) for table TRefFeeType',
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
-- #Rows Exported: 4
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
