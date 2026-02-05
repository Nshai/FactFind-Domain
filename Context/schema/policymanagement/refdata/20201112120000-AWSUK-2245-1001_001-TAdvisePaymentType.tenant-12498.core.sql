 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TAdvisePaymentType
--    Join: 
--   Where: WHERE TenantId=12498
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'B4AB2866-34A2-44A8-AC05-04AB892F2A65'
     AND TenantId = 12498
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TAdvisePaymentType ON; 
 
        INSERT INTO TAdvisePaymentType([AdvisePaymentTypeId], [TenantId], [IsArchived], [ConcurrencyId], [Name], [IsSystemDefined], [GroupId], [RefAdvisePaidById], [PaymentProviderId])
        SELECT 33225,12498,1,2, 'Cheque',1,NULL,1,NULL UNION ALL 
        SELECT 33226,12498,1,2, 'Debit Card',1,NULL,1,NULL UNION ALL 
        SELECT 33227,12498,1,2, 'Credit Card',1,NULL,1,NULL UNION ALL 
        SELECT 33228,12498,1,2, 'Cash Account',1,NULL,1,NULL UNION ALL 
        SELECT 33229,12498,1,2, 'Fund Manager Charges',1,NULL,1,NULL UNION ALL 
        SELECT 33230,12498,1,2, 'Standing Order',1,NULL,1,NULL UNION ALL 
        SELECT 33231,12498,1,2, 'Income received from other sources',1,NULL,1,NULL UNION ALL 
        SELECT 33232,12498,0,1, 'By Provider',1,NULL,2,NULL UNION ALL 
        SELECT 33818,12498,0,0, 'By Client',0,NULL,1,NULL 
 
        SET IDENTITY_INSERT TAdvisePaymentType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'B4AB2866-34A2-44A8-AC05-04AB892F2A65', 
         'Initial load (9 total rows, file 1 of 1) for table TAdvisePaymentType',
         12498, 
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
