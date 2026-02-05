 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefClientType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'FABAC1A6-BF49-4DC7-B2B6-35D32E67D7BD'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefClientType ON; 
 
        INSERT INTO TRefClientType([RefClientTypeId], [Name], [ClientTypeGroup], [ConcurrencyId])
        SELECT 1, 'Retail Client', 'Financial Advice', 1 UNION ALL 
        SELECT 2, 'Wholesale Client', 'Financial Advice', 1 UNION ALL 
        SELECT 3, 'Eligible Counterparty', 'Financial Advice', 1 UNION ALL 
        SELECT 4, 'Residential Client', 'Mortgage', 1 UNION ALL 
        SELECT 5, 'Commercial Lending', 'Mortgage', 1 UNION ALL 
        SELECT 6, 'Personal Insurance', 'Insurance', 1 UNION ALL 
        SELECT 7, 'Business Insurance', 'Insurance', 1 
 
        SET IDENTITY_INSERT TRefClientType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'FABAC1A6-BF49-4DC7-B2B6-35D32E67D7BD', 
         'Initial load (7 total rows, file 1 of 1) for table TRefClientType',
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

