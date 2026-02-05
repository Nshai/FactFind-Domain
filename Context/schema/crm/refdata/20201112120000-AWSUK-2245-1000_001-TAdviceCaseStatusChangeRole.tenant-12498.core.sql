 
-----------------------------------------------------------------------------
-- Table: CRM.TAdviceCaseStatusChangeRole
--    Join: join TAdviceCaseStatusChange c on c.AdviceCaseStatusChangeId = TAdviceCaseStatusChangeRole.AdviceCaseStatusChangeId
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '797999B0-B89E-4362-85B8-12B91936FFB4'
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
        SET IDENTITY_INSERT TAdviceCaseStatusChangeRole ON; 
 
        INSERT INTO TAdviceCaseStatusChangeRole([AdviceCaseStatusChangeRoleId], [AdviceCaseStatusChangeId], [RoleId], [ConcurrencyId])
        SELECT 140914,14330,34609,1 UNION ALL 
        SELECT 140915,14330,34610,1 UNION ALL 
        SELECT 140916,14330,34611,1 UNION ALL 
        SELECT 140917,14330,34612,1 UNION ALL 
        SELECT 140919,14330,34614,1 UNION ALL 
        SELECT 140920,14330,34615,1 UNION ALL 
        SELECT 140922,14331,34609,1 UNION ALL 
        SELECT 140923,14331,34610,1 UNION ALL 
        SELECT 140924,14331,34611,1 UNION ALL 
        SELECT 140925,14331,34612,1 UNION ALL 
        SELECT 140927,14331,34614,1 UNION ALL 
        SELECT 140928,14331,34615,1 UNION ALL 
        SELECT 140930,14332,34609,1 UNION ALL 
        SELECT 140931,14332,34610,1 UNION ALL 
        SELECT 140932,14332,34611,1 UNION ALL 
        SELECT 140933,14332,34612,1 UNION ALL 
        SELECT 140935,14332,34614,1 UNION ALL 
        SELECT 140936,14332,34615,1 UNION ALL 
        SELECT 140938,14333,34609,1 UNION ALL 
        SELECT 140939,14333,34610,1 UNION ALL 
        SELECT 140940,14333,34611,1 UNION ALL 
        SELECT 140941,14333,34612,1 UNION ALL 
        SELECT 140943,14333,34614,1 UNION ALL 
        SELECT 140944,14333,34615,1 
 
        SET IDENTITY_INSERT TAdviceCaseStatusChangeRole OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '797999B0-B89E-4362-85B8-12B91936FFB4', 
         'Initial load (24 total rows, file 1 of 1) for table TAdviceCaseStatusChangeRole',
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
-- #Rows Exported: 24
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
