USE [administration];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT
    @ScriptGUID = 'DD34AF5F-A6FB-42D2-8504-17EF5987708C',
    @Comments = 'IMPSTM-723 Remove licenses for delete portfolio action.'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: The script removes delete portfolio action

-- Expected row counts:
--(2 row affected)
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount INT
       ,@StampAction CHAR(1) = 'D'
       ,@StampDateTime DATETIME = GETUTCDATE()
       ,@SystemToDeleteId INT

        SELECT @SystemToDeleteId = [SystemId]
        FROM [dbo].[TSystem]
        WHERE SystemPath = 'portfolio.actions.delete'


BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

        DELETE FROM [dbo].[TRefLicenseTypeToSystem]
        OUTPUT deleted.[RefLicenseTypeToSystemId]
            , deleted.[RefLicenseTypeId]
            , deleted.[SystemId]
            , deleted.[ConcurrencyId]
            , @StampAction
            , @StampDateTime
            , '0'
        INTO [dbo].[TRefLicenseTypeToSystemAudit]([RefLicenseTypeToSystemId], [RefLicenseTypeId], [SystemId], [ConcurrencyId], [StampAction], [StampDateTime], [StampUser])
        WHERE SystemId = @SystemToDeleteId

        INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    IF @starttrancount = 0
        COMMIT TRANSACTION

END TRY
BEGIN CATCH

       DECLARE @ErrorSeverity INT
       DECLARE @ErrorState INT
       DECLARE @ErrorLine INT
       DECLARE @ErrorNumber INT

       SELECT @ErrorMessage = ERROR_MESSAGE(),
       @ErrorSeverity = ERROR_SEVERITY(),
       @ErrorState = ERROR_STATE(),
       @ErrorNumber = ERROR_NUMBER(),
       @ErrorLine = ERROR_LINE()

    IF XACT_STATE() <> 0 AND @starttrancount = 0
        ROLLBACK TRANSACTION

       RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;