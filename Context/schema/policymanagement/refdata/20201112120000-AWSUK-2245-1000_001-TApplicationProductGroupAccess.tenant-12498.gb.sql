 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TApplicationProductGroupAccess
--    Join: JOIN TApplicationlink l on l.ApplicationLinkId = TApplicationProductGroupAccess.ApplicationLinkId
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '739348E5-D019-448D-92D0-057E4241BE66'
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
        SET IDENTITY_INSERT TApplicationProductGroupAccess ON; 
 
        INSERT INTO TApplicationProductGroupAccess([ApplicationProductGroupAccessId], [ApplicationLinkId], [RefProductGroupId], [AllowAccess], [ConcurrencyId])
        SELECT 205392,105421,7,0,1 UNION ALL 
        SELECT 205393,105423,8,1,1 UNION ALL 
        SELECT 205382,105424,1,1,2 UNION ALL 
        SELECT 205383,105424,2,1,2 UNION ALL 
        SELECT 205384,105424,4,1,1 UNION ALL 
        SELECT 205385,105424,5,1,1 UNION ALL 
        SELECT 205386,105424,6,1,1 UNION ALL 
        SELECT 205387,105425,1,1,2 UNION ALL 
        SELECT 205388,105425,2,1,2 UNION ALL 
        SELECT 205389,105425,3,0,1 UNION ALL 
        SELECT 205390,105425,4,0,1 UNION ALL 
        SELECT 205391,105425,5,0,1 UNION ALL 
        SELECT 205397,105432,7,0,1 UNION ALL 
        SELECT 205399,105433,11,0,1 UNION ALL 
        SELECT 205400,105433,12,0,1 UNION ALL 
        SELECT 205401,105433,13,0,1 UNION ALL 
        SELECT 205402,105433,14,0,1 UNION ALL 
        SELECT 205403,105433,15,0,1 UNION ALL 
        SELECT 205404,105433,17,0,1 UNION ALL 
        SELECT 205405,105433,18,0,1 UNION ALL 
        SELECT 205435,105440,4,0,1 UNION ALL 
        SELECT 205438,105440,4,0,1 UNION ALL 
        SELECT 205447,105440,4,0,1 UNION ALL 
        SELECT 205439,105440,9,0,1 UNION ALL 
        SELECT 205448,105440,9,0,1 UNION ALL 
        SELECT 205440,105440,16,0,1 UNION ALL 
        SELECT 205449,105440,16,0,1 UNION ALL 
        SELECT 205436,105441,4,0,1 UNION ALL 
        SELECT 205441,105441,4,0,1 UNION ALL 
        SELECT 205450,105441,4,0,1 UNION ALL 
        SELECT 205442,105441,9,0,1 UNION ALL 
        SELECT 205451,105441,9,0,1 UNION ALL 
        SELECT 205443,105441,16,0,1 UNION ALL 
        SELECT 205452,105441,16,0,1 UNION ALL 
        SELECT 205437,105442,4,0,1 UNION ALL 
        SELECT 205444,105442,4,0,1 UNION ALL 
        SELECT 205453,105442,4,0,1 UNION ALL 
        SELECT 205445,105442,9,0,1 UNION ALL 
        SELECT 205454,105442,9,0,1 UNION ALL 
        SELECT 205446,105442,16,0,1 UNION ALL 
        SELECT 205455,105442,16,0,1 UNION ALL 
        SELECT 205462,105445,4,0,1 UNION ALL 
        SELECT 205472,105445,9,0,1 UNION ALL 
        SELECT 205468,105446,4,0,1 UNION ALL 
        SELECT 205464,105447,4,0,1 UNION ALL 
        SELECT 205474,105447,9,0,1 UNION ALL 
        SELECT 205469,105448,4,0,1 UNION ALL 
        SELECT 205466,105449,4,0,1 UNION ALL 
        SELECT 205476,105449,9,0,1 UNION ALL 
        SELECT 205470,105450,4,0,1 
 
        SET IDENTITY_INSERT TApplicationProductGroupAccess OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '739348E5-D019-448D-92D0-057E4241BE66', 
         'Initial load (50 total rows, file 1 of 1) for table TApplicationProductGroupAccess',
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
-- #Rows Exported: 50
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
