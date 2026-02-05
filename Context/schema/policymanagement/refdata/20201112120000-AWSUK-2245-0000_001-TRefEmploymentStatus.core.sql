 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefEmploymentStatus
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '23A9599D-E51D-44EF-911F-4703FC25C0E0'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefEmploymentStatus ON; 
 
        INSERT INTO TRefEmploymentStatus([RefEmploymentStatusId], [Name], [ConcurrencyId])
        SELECT 1, 'Employed',1 UNION ALL 
        SELECT 2, 'SelfEmployed',1 UNION ALL 
        SELECT 3, 'ShareholdingDirector',1 UNION ALL 
        SELECT 4, 'Proprietor',1 UNION ALL 
        SELECT 5, 'Unemployed',1 UNION ALL 
        SELECT 6, 'Retired',1 UNION ALL 
        SELECT 7, 'FixedTermContractWorker',1 
 
        SET IDENTITY_INSERT TRefEmploymentStatus OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '23A9599D-E51D-44EF-911F-4703FC25C0E0', 
         'Initial load (7 total rows, file 1 of 1) for table TRefEmploymentStatus',
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
-- #Rows Exported: 7
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
