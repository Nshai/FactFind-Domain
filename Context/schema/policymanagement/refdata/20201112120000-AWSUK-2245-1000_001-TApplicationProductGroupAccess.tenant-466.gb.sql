 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TApplicationProductGroupAccess
--    Join: JOIN TApplicationlink l on l.ApplicationLinkId = TApplicationProductGroupAccess.ApplicationLinkId
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '739348E5-D019-448D-92D0-057E4241BE66'
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
        SET IDENTITY_INSERT TApplicationProductGroupAccess ON; 
 
        INSERT INTO TApplicationProductGroupAccess([ApplicationProductGroupAccessId], [ApplicationLinkId], [RefProductGroupId], [AllowAccess], [ConcurrencyId])
        SELECT 1673,557,1,0,1 UNION ALL 
        SELECT 6675,557,2,0,1 UNION ALL 
        SELECT 20707,557,4,0,1 UNION ALL 
        SELECT 17798,557,5,0,1 UNION ALL 
        SELECT 19165,557,6,0,1 UNION ALL 
        SELECT 1674,558,1,0,1 UNION ALL 
        SELECT 1675,558,2,0,1 UNION ALL 
        SELECT 1676,558,3,0,1 UNION ALL 
        SELECT 1677,558,4,0,1 UNION ALL 
        SELECT 1678,558,5,0,1 UNION ALL 
        SELECT 26485,8917,7,0,1 UNION ALL 
        SELECT 11429,11988,8,0,1 UNION ALL 
        SELECT 28296,27961,7,0,1 UNION ALL 
        SELECT 35907,34172,11,0,1 UNION ALL 
        SELECT 37938,34172,12,0,1 UNION ALL 
        SELECT 39969,34172,13,0,1 UNION ALL 
        SELECT 42000,34172,14,0,1 UNION ALL 
        SELECT 44031,34172,15,0,1 UNION ALL 
        SELECT 100026,34172,17,0,1 UNION ALL 
        SELECT 111016,34172,18,0,1 UNION ALL 
        SELECT 80964,53199,4,0,1 UNION ALL 
        SELECT 82677,54786,4,0,1 UNION ALL 
        SELECT 82678,54786,9,0,1 UNION ALL 
        SELECT 88899,54786,16,0,1 UNION ALL 
        SELECT 85851,56373,4,0,1 UNION ALL 
        SELECT 85852,56373,9,0,1 UNION ALL 
        SELECT 90486,56373,16,0,1 UNION ALL 
        SELECT 113317,66790,4,0,1 UNION ALL 
        SELECT 115070,68543,4,0,1 UNION ALL 
        SELECT 116874,70296,4,0,1 UNION ALL 
        SELECT 116875,70296,9,0,1 UNION ALL 
        SELECT 120329,72049,4,0,1 UNION ALL 
        SELECT 122133,73802,4,0,1 UNION ALL 
        SELECT 122134,73802,9,0,1 UNION ALL 
        SELECT 125588,75555,4,0,1 
 
        SET IDENTITY_INSERT TApplicationProductGroupAccess OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '739348E5-D019-448D-92D0-057E4241BE66', 
         'Initial load (35 total rows, file 1 of 1) for table TApplicationProductGroupAccess',
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
-- #Rows Exported: 35
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
