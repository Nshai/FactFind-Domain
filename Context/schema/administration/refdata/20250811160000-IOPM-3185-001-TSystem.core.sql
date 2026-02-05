USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
    , @Comments VARCHAR(255)
    , @SystemIdentifier NVARCHAR(255) = 'saveasdoc'
    , @SystemDescription NVARCHAR(255) = 'Save as Document'
    , @SystemType VARCHAR(10) = '+subaction'
    , @SystemPath NVARCHAR(255) = 'email.actions.saveasdocument'
    , @ParentSystemId INT
    , @ParentSystemPath NVARCHAR(255) = 'email.actions'
    , @StampDateTime DATETIME = GETUTCDATE()
    , @StampAction CHAR(1) = 'C'
    , @StampUser INT = 0
    , @ConcurrencyId INT = 1

/*
Summary
=================================================================
IOPM-3185: New email action and security
DatabaseName        TableName                       Expected Rows
=================================================================
administration      TSystem                         1
administration      TSystemAudit                    1
*/

SELECT
    @ScriptGUID = 'A0704C5A-FACC-43D6-90C0-A1A3D5C91C78',
    @Comments = 'IOPM-3185: New email action and security'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON



BEGIN TRY

    BEGIN TRANSACTION

		SET @ParentSystemId = (SELECT [SystemId] FROM [dbo].[TSystem] WHERE [SystemPath] = @ParentSystemPath)

        IF NOT EXISTS (SELECT 1 FROM [dbo].[TSystem] WHERE [SystemPath] = @SystemPath)
        BEGIN

            INSERT INTO [dbo].[TSystem]
                ([Identifier]
                , [Description]
                , [SystemPath]
                , [SystemType]
                , [ParentId]
                , [ConcurrencyId])
            OUTPUT
                INSERTED.[Identifier]
                , INSERTED.[Description]
                , INSERTED.[SystemPath]
                , INSERTED.[SystemType]
                , INSERTED.[ParentId]
                , INSERTED.[Url]
                , INSERTED.[EntityId]
                , INSERTED.[ConcurrencyId]
                , INSERTED.[SystemId]
                , @StampAction
                , @StampDateTime
                , @StampUser
                , INSERTED.[Order]
            INTO [dbo].[TSystemAudit]
                ([Identifier]
                , [Description]
                , [SystemPath]
                , [SystemType]
                , [ParentId]
                , [Url]
                , [EntityId]
                , [ConcurrencyId]
                , [SystemId]
                , [StampAction]
                , [StampDateTime]
                , [StampUser]
                , [Order])
            VALUES
                (@SystemIdentifier
                , @SystemDescription
                , @SystemPath
                , @SystemType
                , @ParentSystemId
                , @ConcurrencyId)
        END
        INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    COMMIT TRANSACTION

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;