 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefAdvisePaymentType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '7894E752-9D8D-4FE6-AA76-22FE21251531'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefAdvisePaymentType ON; 
 
        INSERT INTO TRefAdvisePaymentType([RefAdvisePaymentTypeId], [Name])
        SELECT 1, 'Cheque' UNION ALL 
        SELECT 2, 'Debit Card' UNION ALL 
        SELECT 3, 'Credit Card' UNION ALL 
        SELECT 4, 'Cash Account' UNION ALL 
        SELECT 5, 'By Provider' UNION ALL 
        SELECT 6, 'Fund Manager Charges' UNION ALL 
        SELECT 7, 'Standing Order' UNION ALL 
        SELECT 8, 'Income received from other sources' 
 
        SET IDENTITY_INSERT TRefAdvisePaymentType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '7894E752-9D8D-4FE6-AA76-22FE21251531', 
         'Initial load (8 total rows, file 1 of 1) for table TRefAdvisePaymentType',
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
