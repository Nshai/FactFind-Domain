 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefWaitingPeriod
--    Join: 
--   Where: WHERE IndigoClientId IS NULL
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '1E31161D-CB91-4983-BC77-C307DC9BF3DB'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefWaitingPeriod ON; 
 
        INSERT INTO TRefWaitingPeriod([RefWaitingPeriodId], [Descriptor], [ArchiveFG], [IndigoClientId], [ConcurrencyId])
        SELECT 1, 'Weeky',0,NULL,1 UNION ALL 
        SELECT 2, 'Monthly',0,NULL,1 UNION ALL 
        SELECT 3, 'Quaterly',0,NULL,1 UNION ALL 
        SELECT 4, 'Bi-Annually',0,NULL,1 UNION ALL 
        SELECT 5, 'Annually',0,NULL,1 
 
        SET IDENTITY_INSERT TRefWaitingPeriod OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '1E31161D-CB91-4983-BC77-C307DC9BF3DB', 
         'Initial load (5 total rows, file 1 of 1) for table TRefWaitingPeriod',
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
-- #Rows Exported: 5
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
