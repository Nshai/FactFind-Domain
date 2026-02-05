 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TApplicationLink
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '6174C921-7090-4F76-8F82-04D5E521BC43'
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
        SET IDENTITY_INSERT TApplicationLink ON; 
 
        INSERT INTO TApplicationLink([ApplicationLinkId], [IndigoClientId], [RefApplicationId], [MaxLicenceCount], [CurrentLicenceCount], [AllowAccess], [ExtranetURL], [ReferenceCode], [ConcurrencyId], [IntegratedSystemConfigRole], [SystemArchived], [WealthLinkEnabled])
        SELECT 105416,12498,5,0,0,1, NULL, NULL,1,0,0,0 UNION ALL 
        SELECT 105417,12498,1000,0,0,1, NULL, NULL,1,0,0,0 UNION ALL 
        SELECT 105418,12498,6,0,0,1, NULL, NULL,1,0,0,0 UNION ALL 
        SELECT 105419,12498,7,NULL,NULL,0, NULL, NULL,0,0,0,0 UNION ALL 
        SELECT 105420,12498,8,0,0,1, NULL, NULL,1,0,0,0 UNION ALL 
        SELECT 105421,12498,10,0,0,1, NULL, NULL,1,0,0,0 UNION ALL 
        SELECT 105423,12498,9,NULL,NULL,0, NULL, NULL,0,0,0,0 UNION ALL 
        SELECT 105424,12498,1,NULL,NULL,1, NULL, NULL,0,1,0,0 UNION ALL 
        SELECT 105425,12498,2,NULL,NULL,1, NULL, NULL,0,1,0,0 UNION ALL 
        SELECT 105426,12498,4,NULL,NULL,1, NULL, NULL,0,1,0,0 UNION ALL 
        SELECT 105427,12498,11,NULL,NULL,1, NULL, NULL,0,0,0,0 UNION ALL 
        SELECT 105428,12498,19,NULL,NULL,1, NULL, NULL,0,0,0,1 UNION ALL 
        SELECT 105429,12498,13,NULL,NULL,0, NULL, NULL,0,0,0,0 UNION ALL 
        SELECT 105430,12498,16,NULL,NULL,0, NULL, NULL,0,4,0,0 UNION ALL 
        SELECT 105432,12498,35,NULL,NULL,1, NULL, NULL,0,2,0,0 UNION ALL 
        SELECT 105433,12498,38,NULL,NULL,1, NULL, NULL,0,2,0,0 UNION ALL 
        SELECT 105439,12498,43,NULL,NULL,1, NULL, NULL,0,9,0,0 UNION ALL 
        SELECT 105440,12498,44,NULL,NULL,0, NULL, NULL,0,1,0,1 UNION ALL 
        SELECT 105441,12498,44,NULL,NULL,0, NULL, NULL,0,2,0,1 UNION ALL 
        SELECT 105442,12498,44,NULL,NULL,0, NULL, NULL,0,5,0,1 UNION ALL 
        SELECT 105443,12498,45,NULL,NULL,0, NULL, NULL,0,1,0,0 UNION ALL 
        SELECT 105444,12498,28,NULL,NULL,0, NULL, NULL,0,7,1,0 UNION ALL 
        SELECT 105445,12498,46,NULL,NULL,0, NULL, NULL,0,1,1,1 UNION ALL 
        SELECT 105446,12498,47,NULL,NULL,0, NULL, NULL,0,1,1,1 UNION ALL 
        SELECT 105447,12498,46,NULL,NULL,0, NULL, NULL,0,2,1,1 UNION ALL 
        SELECT 105448,12498,47,NULL,NULL,0, NULL, NULL,0,2,1,1 UNION ALL 
        SELECT 105449,12498,46,NULL,NULL,0, NULL, NULL,0,5,1,1 UNION ALL 
        SELECT 105450,12498,47,NULL,NULL,0, NULL, NULL,0,5,1,1 
 
        SET IDENTITY_INSERT TApplicationLink OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '6174C921-7090-4F76-8F82-04D5E521BC43', 
         'Initial load (28 total rows, file 1 of 1) for table TApplicationLink',
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
-- #Rows Exported: 28
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
