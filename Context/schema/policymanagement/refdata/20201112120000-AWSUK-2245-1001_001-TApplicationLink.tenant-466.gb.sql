 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TApplicationLink
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '6174C921-7090-4F76-8F82-04D5E521BC43'
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
        SET IDENTITY_INSERT TApplicationLink ON; 
 
        INSERT INTO TApplicationLink([ApplicationLinkId], [IndigoClientId], [RefApplicationId], [MaxLicenceCount], [CurrentLicenceCount], [AllowAccess], [ExtranetURL], [ReferenceCode], [ConcurrencyId], [IntegratedSystemConfigRole], [SystemArchived], [WealthLinkEnabled])
        SELECT 557,466,1,NULL,NULL,1, NULL, NULL,2,1,0,0 UNION ALL 
        SELECT 558,466,2,NULL,NULL,1, NULL, NULL,2,1,0,0 UNION ALL 
        SELECT 898,466,4,NULL,NULL,1, NULL, NULL,2,1,0,0 UNION ALL 
        SELECT 1423,466,5,NULL,NULL,1, NULL, NULL,2,0,0,0 UNION ALL 
        SELECT 2353,466,6,0,0,1, NULL, NULL,2,1,0,0 UNION ALL 
        SELECT 3160,466,7,NULL,NULL,0, NULL, NULL,2,0,0,0 UNION ALL 
        SELECT 8046,466,8,NULL,NULL,1, NULL, NULL,2,1,0,0 UNION ALL 
        SELECT 8917,466,10,NULL,NULL,1, NULL, NULL,2,2,0,0 UNION ALL 
        SELECT 11988,466,9,NULL,NULL,0, NULL, NULL,2,1,0,0 UNION ALL 
        SELECT 12370,466,11,0,0,1, NULL, NULL,1,0,0,0 UNION ALL 
        SELECT 13355,466,19,0,0,1, NULL, NULL,3,0,0,1 UNION ALL 
        SELECT 15005,466,13,NULL,NULL,0, NULL, NULL,1,0,0,0 UNION ALL 
        SELECT 16363,466,16,NULL,NULL,0, NULL, NULL,0,4,0,0 UNION ALL 
        SELECT 27961,466,35,NULL,NULL,1, NULL, NULL,1,2,0,0 UNION ALL 
        SELECT 34172,466,38,NULL,NULL,1, NULL, NULL,1,2,0,0 UNION ALL 
        SELECT 48852,466,43,NULL,NULL,1, NULL, NULL,1,9,0,0 UNION ALL 
        SELECT 53199,466,44,NULL,NULL,0, NULL, NULL,2,1,0,1 UNION ALL 
        SELECT 54786,466,44,NULL,NULL,0, NULL, NULL,2,2,0,1 UNION ALL 
        SELECT 56373,466,44,NULL,NULL,0, NULL, NULL,2,5,0,1 UNION ALL 
        SELECT 60864,466,45,NULL,NULL,0, NULL, NULL,1,1,0,0 UNION ALL 
        SELECT 62511,466,28,NULL,NULL,0, NULL, NULL,1,7,1,0 UNION ALL 
        SELECT 66790,466,46,NULL,NULL,0, NULL, NULL,2,1,1,1 UNION ALL 
        SELECT 68543,466,47,NULL,NULL,0, NULL, NULL,2,1,1,1 UNION ALL 
        SELECT 70296,466,46,NULL,NULL,0, NULL, NULL,2,2,1,1 UNION ALL 
        SELECT 72049,466,47,NULL,NULL,0, NULL, NULL,2,2,1,1 UNION ALL 
        SELECT 73802,466,46,NULL,NULL,0, NULL, NULL,2,5,1,1 UNION ALL 
        SELECT 75555,466,47,NULL,NULL,0, NULL, NULL,2,5,1,1 
 
        SET IDENTITY_INSERT TApplicationLink OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '6174C921-7090-4F76-8F82-04D5E521BC43', 
         'Initial load (27 total rows, file 1 of 1) for table TApplicationLink',
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
-- #Rows Exported: 27
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
