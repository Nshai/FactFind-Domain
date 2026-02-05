-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefApplication for AU
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
USE PolicyManagement
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'DE019F56-1CEB-41AA-8C43-25590FB04D64'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefApplication ON; 
 
        INSERT INTO TRefApplication([RefApplicationId], [ApplicationName], [ApplicationShortName], [RefApplicationTypeId], [ImageName], [IsArchived], [ConcurrencyId], [AuthenticationMode])
        SELECT 7, 'Third-Party Email Apps', 'EM',4, NULL,0,1,0 UNION ALL 
        SELECT 43, 'FE Analytics', 'FE',14, NULL,0,1,1 
 
        SET IDENTITY_INSERT TRefApplication OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'DE019F56-1CEB-41AA-8C43-25590FB04D64', 
         'Initial load (2 total rows, file 1 of 1) for table TRefApplication',
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
