 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefEmploymentType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '00EE5E9F-8E3E-4A6B-8D65-499A81DD2DAE'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefEmploymentType ON; 
 
        INSERT INTO TRefEmploymentType([RefEmploymentTypeId], [Name], [ConcurrencyId])
        SELECT 1, 'Permanent',1 UNION ALL 
        SELECT 2, 'FixedTermContractWorker',1 UNION ALL 
        SELECT 3, 'SelfEmployed',1 UNION ALL 
        SELECT 4, 'Retired',1 
 
        SET IDENTITY_INSERT TRefEmploymentType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '00EE5E9F-8E3E-4A6B-8D65-499A81DD2DAE', 
         'Initial load (4 total rows, file 1 of 1) for table TRefEmploymentType',
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
