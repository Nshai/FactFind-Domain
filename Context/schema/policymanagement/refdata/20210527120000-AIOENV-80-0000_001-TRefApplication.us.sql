USE [PolicyManagement]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)

SELECT @ScriptGUID = 'a8bfadd1-2e34-4c15-8b0c-b497585324ca',
       @Comments = 'AIOENV-80 initial load for table TRefApplication for us environments'
      
 -- check if this script has already run     
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN; 

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION

        SET IDENTITY_INSERT TRefApplication ON; 
 
        INSERT INTO TRefApplication([RefApplicationId], [ApplicationName], [ApplicationShortName], [RefApplicationTypeId], [ImageName], [IsArchived], [ConcurrencyId], [AuthenticationMode])
        SELECT 7, 'Third-Party Email Apps', 'EM',4, NULL,0,1,0
 
        SET IDENTITY_INSERT TRefApplication OFF

         -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (@ScriptGUID, @Comments, null, getdate() )
 
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