 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TLifeCycle
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '7BA9D2DC-A8F0-440B-923C-0F9781B62719'
     AND TenantId = 466
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TLifeCycle ON; 
 
        INSERT INTO TLifeCycle([LifeCycleId], [Name], [Descriptor], [Status], [PreQueueBehaviour], [PostQueueBehaviour], [CreatedDate], [CreatedUser], [IndigoClientId], [ConcurrencyId], [IgnorePostCheckIfPreHasBeenCompleted])
        SELECT 6304, 'Pre-Existing', 'Pre-Existing',1, 'N/A', 'N/A','Nov 21 2007  4:05PM',0,466,1,0 UNION ALL 
        SELECT 6305, 'New Business - Investments', 'New Business - Investments',1, 'N/A', 'N/A','Nov 21 2007  4:05PM',0,466,1,0 UNION ALL 
        SELECT 6306, 'New Business - Protection', 'New Business - Protection',1, 'N/A', 'N/A','Nov 21 2007  4:05PM',0,466,1,0 UNION ALL 
        SELECT 6307, 'New Business - Mortgages', 'New Business - Mortgages',1, 'N/A', 'N/A','Nov 21 2007  4:05PM',0,466,1,0 UNION ALL 
        SELECT 6308, 'New Business - Pension', 'New Business - Pension',1, 'N/A', 'N/A','Nov 21 2007  4:05PM',0,466,1,0 UNION ALL 
        SELECT 22437, 'DLP', 'DLP',1, 'N/A', 'N/A','Jan 11 2014  2:36PM',0,466,1,0 UNION ALL 
        SELECT 32779, 'New Business - Integration', 'New Business - Integration',0, 'N/A', 'N/A','Aug  1 2015 11:15AM',0,466,1,0 
 
        SET IDENTITY_INSERT TLifeCycle OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '7BA9D2DC-A8F0-440B-923C-0F9781B62719', 
         'Initial load (7 total rows, file 1 of 1) for table TLifeCycle',
         466, 
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
