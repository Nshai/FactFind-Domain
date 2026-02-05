USE [administration];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT
    @ScriptGUID = '16AAA822-1D33-40C8-BF43-DC518C4E792F',
    @Comments = 'IMPSTM-723 Rename systempath for create/update/delete action from addportfolio to manageportfolio.'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: The script renames systempath for create/update/delete action from addportfolio to manageportfolio

-- Expected row counts:
--(1 row affected)
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int
       ,@StampAction char(1) = 'U'
       ,@StampDateTime AS DATETIME = GETUTCDATE()
       ,@StampUser AS VARCHAR(255) = '0'


BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

        UPDATE [administration].[dbo].[TSystem]
        SET SystemPath = 'adviserworkplace.fundanalysis.actions.manageportfolio'
        OUTPUT deleted.[SystemId]
            , deleted.[Identifier]
            , deleted.[Description]
            , deleted.[SystemPath]
            , deleted.[SystemType]
            , deleted.[ParentId]
            , deleted.[ConcurrencyId]
            , @StampAction
            , @StampDateTime
            , @StampUser
        INTO [administration].[dbo].[TSystemAudit]([SystemId], [Identifier], [Description], [SystemPath], [SystemType], [ParentId], [ConcurrencyId], [StampAction], [StampDateTime], [StampUser])
        WHERE SystemPath = 'adviserworkplace.fundanalysis.actions.addportfolio'

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