 
-----------------------------------------------------------------------------
-- Table: CRM.TOpportunityStatus
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '67902869-82FB-4A88-B450-37D0C49BB927'
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
        SET IDENTITY_INSERT TOpportunityStatus ON; 
 
        INSERT INTO TOpportunityStatus([OpportunityStatusId], [OpportunityStatusName], [IndigoClientId], [InitialStatusFG], [ArchiveFG], [AutoCloseOpportunityFg], [OpportunityStatusTypeId], [ConcurrencyId])
        SELECT 15480, '1. New',12498,1,0,0,1,4 UNION ALL 
        SELECT 15483, '3a. Recommendation accepted',12498,0,0,1,2,4 UNION ALL 
        SELECT 15488, '3b. Recommendation declined',12498,0,0,1,3,2 UNION ALL 
        SELECT 16735, '2. In progress',12498,0,0,0,1,2 
 
        SET IDENTITY_INSERT TOpportunityStatus OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '67902869-82FB-4A88-B450-37D0C49BB927', 
         'Initial load (4 total rows, file 1 of 1) for table TOpportunityStatus',
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
-- #Rows Exported: 4
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
