 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValRefEligibilityFlag
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '24B669C8-849A-4521-9290-E480E87C9481'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TValRefEligibilityFlag ON; 
 
        INSERT INTO TValRefEligibilityFlag([ValRefEligibilityFlagId], [EligibilityFlag], [EligibilityDescription], [ConcurrencyId], [EligibilityLevel], [InEligibilityDescription])
        SELECT 1,1, 'Plan has a reference number',1, 'plan', 'Policy Ref is empty' UNION ALL 
        SELECT 2,2, 'Plan is In force/Paid Up',1, 'plan', 'Policy is not In force or Paid Up' UNION ALL 
        SELECT 3,4, 'Adviser allowed',1, 'plan', 'Adviser is not Access Granted' UNION ALL 
        SELECT 4,8, 'Plan is not excluded',1, 'plan', 'Plan is excluded from scheduled valuations' UNION ALL 
        SELECT 5,16, 'Plan type allowed',1, 'plan', 'Plan type is not supported for valuations' UNION ALL 
        SELECT 6,32, 'Plan is not a top up plan',1, 'plan', 'Top up cannot be valued' UNION ALL 
        SELECT 7,64, 'Plan is not a sub plan',1, 'plan', 'Sub plans cannot be valued' UNION ALL 
        SELECT 9,256, 'User has access to this plan',1, 'scheduledplan', NULL UNION ALL 
        SELECT 10,512, 'Group has access to this plan',1, 'scheduledplan', NULL UNION ALL 
        SELECT 11,1024, 'Scheduled Plan is not a duplicate plan',1, 'scheduledplan', 'Two or more plans found with same Policy Ref' UNION ALL 
        SELECT 12,2048, 'Scheduled user has credentials',1, 'scheduledplan', NULL 
 
        SET IDENTITY_INSERT TValRefEligibilityFlag OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '24B669C8-849A-4521-9290-E480E87C9481', 
         'Initial load (11 total rows, file 1 of 1) for table TValRefEligibilityFlag',
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
-- #Rows Exported: 11
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
