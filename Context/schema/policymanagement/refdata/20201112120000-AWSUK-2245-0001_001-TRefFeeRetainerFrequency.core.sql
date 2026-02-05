 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefFeeRetainerFrequency
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '38009DE9-BFE0-4807-9A03-5C424FE17461'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefFeeRetainerFrequency ON; 
 
        INSERT INTO TRefFeeRetainerFrequency([RefFeeRetainerFrequencyId], [PeriodName], [NumMonths], [Extensible], [ConcurrencyId])
        SELECT 4, 'Annually',12,NULL,1 UNION ALL 
        SELECT 3, 'Half Yearly',6,NULL,1 UNION ALL 
        SELECT 2, 'Quarterly',3,NULL,1 UNION ALL 
        SELECT 1, 'Monthly',1,NULL,1 
 
        SET IDENTITY_INSERT TRefFeeRetainerFrequency OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '38009DE9-BFE0-4807-9A03-5C424FE17461', 
         'Initial load (4 total rows, file 1 of 1) for table TRefFeeRetainerFrequency',
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
