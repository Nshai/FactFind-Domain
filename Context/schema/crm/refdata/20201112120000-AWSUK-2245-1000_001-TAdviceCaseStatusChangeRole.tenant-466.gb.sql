 
-----------------------------------------------------------------------------
-- Table: CRM.TAdviceCaseStatusChangeRole
--    Join: join TAdviceCaseStatusChange c on c.AdviceCaseStatusChangeId = TAdviceCaseStatusChangeRole.AdviceCaseStatusChangeId
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '797999B0-B89E-4362-85B8-12B91936FFB4'
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
        SET IDENTITY_INSERT TAdviceCaseStatusChangeRole ON; 
 
        INSERT INTO TAdviceCaseStatusChangeRole([AdviceCaseStatusChangeRoleId], [AdviceCaseStatusChangeId], [RoleId], [ConcurrencyId])
        SELECT 8637,877,4011,1 UNION ALL 
        SELECT 8638,877,4012,1 UNION ALL 
        SELECT 8639,877,4013,1 UNION ALL 
        SELECT 8640,877,4014,1 UNION ALL 
        SELECT 8641,877,4015,1 UNION ALL 
        SELECT 8642,877,4016,1 UNION ALL 
        SELECT 8643,877,4017,1 UNION ALL 
        SELECT 8644,877,4019,1 UNION ALL 
        SELECT 8645,877,4018,1 UNION ALL 
        SELECT 8646,877,4010,1 UNION ALL 
        SELECT 8647,878,4010,1 UNION ALL 
        SELECT 8648,878,4018,1 UNION ALL 
        SELECT 8649,878,4019,1 UNION ALL 
        SELECT 8650,878,4017,1 UNION ALL 
        SELECT 8651,878,4016,1 UNION ALL 
        SELECT 8652,878,4015,1 UNION ALL 
        SELECT 8653,878,4014,1 UNION ALL 
        SELECT 8654,878,4013,1 UNION ALL 
        SELECT 8655,878,4012,1 UNION ALL 
        SELECT 8656,878,4011,1 UNION ALL 
        SELECT 8657,879,4011,1 UNION ALL 
        SELECT 8658,879,4012,1 UNION ALL 
        SELECT 8659,879,4013,1 UNION ALL 
        SELECT 8660,879,4014,1 UNION ALL 
        SELECT 8661,879,4015,1 UNION ALL 
        SELECT 8662,879,4016,1 UNION ALL 
        SELECT 8663,879,4017,1 UNION ALL 
        SELECT 8664,879,4019,1 UNION ALL 
        SELECT 8665,879,4018,1 UNION ALL 
        SELECT 8666,879,4010,1 UNION ALL 
        SELECT 8667,880,4010,1 UNION ALL 
        SELECT 8668,880,4018,1 UNION ALL 
        SELECT 8669,880,4019,1 UNION ALL 
        SELECT 8670,880,4017,1 UNION ALL 
        SELECT 8671,880,4016,1 UNION ALL 
        SELECT 8672,880,4015,1 UNION ALL 
        SELECT 8673,880,4014,1 UNION ALL 
        SELECT 8674,880,4013,1 UNION ALL 
        SELECT 8675,880,4012,1 UNION ALL 
        SELECT 8676,880,4011,1 
 
        SET IDENTITY_INSERT TAdviceCaseStatusChangeRole OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '797999B0-B89E-4362-85B8-12B91936FFB4', 
         'Initial load (40 total rows, file 1 of 1) for table TAdviceCaseStatusChangeRole',
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
-- #Rows Exported: 40
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
