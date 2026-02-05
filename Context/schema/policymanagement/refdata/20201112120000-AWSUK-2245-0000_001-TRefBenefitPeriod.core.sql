 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefBenefitPeriod
--    Join: 
--   Where: WHERE IndigoClientId IS NULL
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '47A31966-667C-485A-B923-2F4BCA6A9E84'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefBenefitPeriod ON; 
 
        INSERT INTO TRefBenefitPeriod([RefBenefitPeriodId], [Descriptor], [ArchiveFG], [IndigoClientId], [ConcurrencyId])
        SELECT 1, 'Weekly',0,NULL,1 UNION ALL 
        SELECT 2, 'Monthly',0,NULL,1 UNION ALL 
        SELECT 3, 'Quaterly',0,NULL,1 UNION ALL 
        SELECT 4, 'Bi-Annually',0,NULL,1 UNION ALL 
        SELECT 5, 'Annually',0,NULL,1 UNION ALL 
        SELECT 6, '9 Months',0,NULL,1 UNION ALL 
        SELECT 7, '24 Months',0,NULL,1 UNION ALL 
        SELECT 8, 'Other',0,NULL,1 
 
        SET IDENTITY_INSERT TRefBenefitPeriod OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '47A31966-667C-485A-B923-2F4BCA6A9E84', 
         'Initial load (8 total rows, file 1 of 1) for table TRefBenefitPeriod',
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
