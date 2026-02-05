USE [PolicyManagement]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)

SELECT @ScriptGUID = 'A8F9E2D3-4C5B-6789-A012-202509011604',
    @Comments = 'IOADV-4359 Update Pension Commencement Lump Sum (PCLS) name to remove (3) suffix'

-- check if this script has already run
IF EXISTS (SELECT 1
FROM TExecutedDataScript
WHERE ScriptGUID = @ScriptGUID)
	RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION

        -- update the record to remove (3) from the name
        UPDATE TRefWithdrawalSubType 
        SET [Name] = 'Pension Commencement Lump Sum (PCLS)'
        WHERE RefWithdrawalSubTypeId = 2
    AND [Name] = 'Pension Commencement Lump Sum (PCLS) (3)'

        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript
    (ScriptGuid, Comments, TenantId, Timestamp)
VALUES
    (@ScriptGUID, @Comments, null, getdate() )

   IF @starttrancount = 0
    COMMIT TRANSACTION

END TRY
BEGIN CATCH
    -- Rollback transaction if it was started in this script
    IF @starttrancount = 0 AND @@TRANCOUNT > 0
        ROLLBACK TRANSACTION
    
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    
    -- Format error message with additional details
    SET @ErrorMessage = 'Error ' + CAST(@ErrorNumber AS VARCHAR(10)) + ' at line ' + CAST(@ErrorLine AS VARCHAR(10)) + ': ' + @ErrorMessage
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF
