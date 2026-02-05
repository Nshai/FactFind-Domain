-----------------------------------------------------------------------------
-- Table: PolicyManagement.TApplicationLink for AU
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
        SELECT 105419,12498,7,NULL,NULL,0, NULL, NULL,0,0,0,0 UNION ALL 
        SELECT 105439,12498,43,NULL,NULL,1, NULL, NULL,0,9,0,0
 
        SET IDENTITY_INSERT TApplicationLink OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '6174C921-7090-4F76-8F82-04D5E521BC43', 
         'Initial load (2 total rows, file 1 of 1) for table TApplicationLink',
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
