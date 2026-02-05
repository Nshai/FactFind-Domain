 
-----------------------------------------------------------------------------
-- Table: Administration.TPolicy
--    Join: JOIN TRole r on r.RoleId = TPolicy.RoleId
--   Where: WHERE r.IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '17BCBFDD-E6F6-4E7C-A8BB-5AFF5697F20D'
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
        SET IDENTITY_INSERT TPolicy ON; 
 
        INSERT INTO TPolicy([PolicyId], [EntityId], [RightMask], [AdvancedMask], [RoleId], [Propogate], [Applied], [IndigoClientId], [ConcurrencyId])
        SELECT 105970,2,3,0,34609,0, 'yes',12498,1 UNION ALL 
        SELECT 105971,5,3,0,34609,0, 'yes',12498,1 UNION ALL 
        SELECT 105972,7,3,0,34609,0, 'yes',12498,1 UNION ALL 
        SELECT 105973,8,3,0,34609,0, 'yes',12498,1 UNION ALL 
        SELECT 105974,2,1,0,34610,0, 'yes',12498,1 UNION ALL 
        SELECT 105975,7,1,0,34610,0, 'yes',12498,1 UNION ALL 
        SELECT 105976,5,1,0,34610,0, 'yes',12498,1 UNION ALL 
        SELECT 105977,8,1,0,34610,0, 'yes',12498,1 UNION ALL 
        SELECT 105978,2,0,0,34611,0, 'yes',12498,2 UNION ALL 
        SELECT 105979,7,1,0,34611,0, 'yes',12498,1 UNION ALL 
        SELECT 105980,5,1,0,34611,0, 'yes',12498,1 UNION ALL 
        SELECT 105981,8,1,0,34611,0, 'yes',12498,1 UNION ALL 
        SELECT 105982,7,3,0,34612,0, 'yes',12498,2 UNION ALL 
        SELECT 105983,2,3,0,34612,0, 'yes',12498,1 UNION ALL 
        SELECT 105984,5,3,0,34612,0, 'yes',12498,2 UNION ALL 
        SELECT 105985,8,3,0,34612,0, 'yes',12498,2 UNION ALL 
        SELECT 105990,2,1,0,34614,0, 'yes',12498,1 UNION ALL 
        SELECT 105991,7,1,0,34614,0, 'yes',12498,1 UNION ALL 
        SELECT 105992,5,1,0,34614,0, 'yes',12498,1 UNION ALL 
        SELECT 105993,8,1,0,34614,0, 'yes',12498,1 UNION ALL 
        SELECT 105994,2,3,0,34615,0, 'yes',12498,2 UNION ALL 
        SELECT 105995,7,3,0,34615,0, 'yes',12498,2 UNION ALL 
        SELECT 105996,8,3,0,34615,0, 'yes',12498,2 UNION ALL 
        SELECT 105997,5,3,0,34615,0, 'yes',12498,2 UNION ALL 
        SELECT 153002,7,3,0,53965,0, 'yes',12498,2 UNION ALL 
        SELECT 153003,2,3,0,53965,0, 'yes',12498,1 UNION ALL 
        SELECT 153004,5,3,0,53965,0, 'yes',12498,2 UNION ALL 
        SELECT 153005,8,3,0,53965,0, 'yes',12498,2 UNION ALL 
        SELECT 153006,7,3,0,53966,0, 'yes',12498,2 UNION ALL 
        SELECT 153007,2,3,0,53966,0, 'yes',12498,1 UNION ALL 
        SELECT 153008,5,3,0,53966,0, 'yes',12498,2 UNION ALL 
        SELECT 153009,8,3,0,53966,0, 'yes',12498,2 
 
        SET IDENTITY_INSERT TPolicy OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '17BCBFDD-E6F6-4E7C-A8BB-5AFF5697F20D', 
         'Initial load (32 total rows, file 1 of 1) for table TPolicy',
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
-- #Rows Exported: 32
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
