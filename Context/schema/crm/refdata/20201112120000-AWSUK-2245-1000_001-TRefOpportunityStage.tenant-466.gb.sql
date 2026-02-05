 
-----------------------------------------------------------------------------
-- Table: CRM.TRefOpportunityStage
--    Join: 
--   Where: WHERE IndClientId=466
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '01BBAC1B-F0AD-4EEE-B817-97E226DA6223'
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
        SET IDENTITY_INSERT TRefOpportunityStage ON; 
 
        INSERT INTO TRefOpportunityStage([RefOpportunityStageId], [IndClientId], [Description], [Probability], [OpenFG], [ClosedFG], [WonFG], [Extensible], [ConcurrencyId])
        SELECT 3681,466, 'Prospecting',10,1,0,0,NULL,1 UNION ALL 
        SELECT 3682,466, 'Qualification',10,1,0,0,NULL,1 UNION ALL 
        SELECT 3683,466, 'Needs Analysis',20,1,0,0,NULL,1 UNION ALL 
        SELECT 3684,466, 'Value Proposition',50,1,0,0,NULL,1 UNION ALL 
        SELECT 3685,466, 'Id. Decision Makers',60,1,0,0,NULL,1 UNION ALL 
        SELECT 3686,466, 'Perception Analysis',70,1,0,0,NULL,1 UNION ALL 
        SELECT 3687,466, 'Proposal/Price Quote',75,1,0,0,NULL,1 UNION ALL 
        SELECT 3688,466, 'Negotiation/Review',90,1,0,0,NULL,1 UNION ALL 
        SELECT 3689,466, 'Closed Won',100,0,1,1,NULL,1 UNION ALL 
        SELECT 3690,466, 'Closed Lost',0,0,1,0,NULL,1 
 
        SET IDENTITY_INSERT TRefOpportunityStage OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '01BBAC1B-F0AD-4EEE-B817-97E226DA6223', 
         'Initial load (10 total rows, file 1 of 1) for table TRefOpportunityStage',
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
-- #Rows Exported: 10
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
