 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefContributionType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'C7DE294E-B7B2-40C0-9456-3C31FCC0A33B'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefContributionType ON; 
 
        INSERT INTO TRefContributionType([RefContributionTypeId], [RefContributionTypeName], [RetireFg], [ConcurrencyId])
        SELECT 4, 'Rebate',0,1 UNION ALL 
        SELECT 3, 'Transfer',0,1 UNION ALL 
        SELECT 2, 'Lump Sum',0,1 UNION ALL 
        SELECT 1, 'Regular',0,1 
 
        SET IDENTITY_INSERT TRefContributionType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'C7DE294E-B7B2-40C0-9456-3C31FCC0A33B', 
         'Initial load (4 total rows, file 1 of 1) for table TRefContributionType',
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
