USE [PolicyManagement]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)

SELECT @ScriptGUID = 'FABAC1A6-BF49-4DC7-B2B6-35D32E67D7BD', -- use guid for GB script in order not to run it for SYS_IE_03
       @Comments = 'AIOENV-80 initial load for table TRefClientType for us environments'
      
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

    -- insert the records
        SET IDENTITY_INSERT TRefClientType ON; 
 
        INSERT INTO TRefClientType([RefClientTypeId], [Name], [ClientTypeGroup], [ConcurrencyId])
        SELECT 1, 'Individual', 'Retail', 1 UNION ALL 
        SELECT 2, 'High Net Worth Individual', 'Retail', 1 UNION ALL 
        SELECT 3, 'Corporation', 'Institutional', 1 UNION ALL 
        SELECT 4, 'Charitable Organization', 'Institutional', 1 UNION ALL 
        SELECT 5, 'Pension', 'Institutional', 1
 
        SET IDENTITY_INSERT TRefClientType OFF

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