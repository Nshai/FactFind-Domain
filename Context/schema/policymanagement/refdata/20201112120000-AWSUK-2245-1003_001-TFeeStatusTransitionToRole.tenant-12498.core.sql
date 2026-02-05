 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TFeeStatusTransitionToRole
--    Join: 
--   Where: WHERE tenantid = 12498
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '38BD5615-7DC1-4795-9946-93C6DDD91472'
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
        SET IDENTITY_INSERT TFeeStatusTransitionToRole ON; 
 
        INSERT INTO TFeeStatusTransitionToRole([FeeStatusTransitionToRoleId], [FeeStatusTransitionId], [TenantId], [RoleId], [ConcurrencyId])
        SELECT 378410,2,12498,34609,1 UNION ALL 
        SELECT 378411,2,12498,34610,1 UNION ALL 
        SELECT 378412,2,12498,34611,1 UNION ALL 
        SELECT 378413,2,12498,34612,1 UNION ALL 
        SELECT 378415,2,12498,34614,1 UNION ALL 
        SELECT 378416,2,12498,34615,1 UNION ALL 
        SELECT 378418,3,12498,34609,1 UNION ALL 
        SELECT 378419,3,12498,34610,1 UNION ALL 
        SELECT 378420,3,12498,34611,1 UNION ALL 
        SELECT 378421,3,12498,34612,1 UNION ALL 
        SELECT 378423,3,12498,34614,1 UNION ALL 
        SELECT 378424,3,12498,34615,1 UNION ALL 
        SELECT 378458,9,12498,34609,1 UNION ALL 
        SELECT 378459,9,12498,34610,1 UNION ALL 
        SELECT 378460,9,12498,34611,1 UNION ALL 
        SELECT 378461,9,12498,34612,1 UNION ALL 
        SELECT 378463,9,12498,34614,1 UNION ALL 
        SELECT 378464,9,12498,34615,1 UNION ALL 
        SELECT 378482,12,12498,34609,1 UNION ALL 
        SELECT 378483,12,12498,34610,1 UNION ALL 
        SELECT 378484,12,12498,34611,1 UNION ALL 
        SELECT 378485,12,12498,34612,1 UNION ALL 
        SELECT 378487,12,12498,34614,1 UNION ALL 
        SELECT 378488,12,12498,34615,1 UNION ALL 
        SELECT 378490,13,12498,34609,1 UNION ALL 
        SELECT 378491,13,12498,34610,1 UNION ALL 
        SELECT 378492,13,12498,34611,1 UNION ALL 
        SELECT 378493,13,12498,34612,1 UNION ALL 
        SELECT 378495,13,12498,34614,1 UNION ALL 
        SELECT 378496,13,12498,34615,1 UNION ALL 
        SELECT 378498,14,12498,34609,1 UNION ALL 
        SELECT 378499,14,12498,34610,1 UNION ALL 
        SELECT 378500,14,12498,34611,1 UNION ALL 
        SELECT 378501,14,12498,34612,1 UNION ALL 
        SELECT 378503,14,12498,34614,1 UNION ALL 
        SELECT 378504,14,12498,34615,1 
 
        SET IDENTITY_INSERT TFeeStatusTransitionToRole OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '38BD5615-7DC1-4795-9946-93C6DDD91472', 
         'Initial load (36 total rows, file 1 of 1) for table TFeeStatusTransitionToRole',
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
-- #Rows Exported: 36
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
