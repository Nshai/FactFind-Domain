USE [administration]


DECLARE @ScriptGUID UNIQUEIDENTIFIER
    , @Comments VARCHAR(255)
    , @VideosSystemIdentifier NVARCHAR(255) = 'videos'
    , @VideosSystemDescription NVARCHAR(255) = 'Videos'
    , @VideosSystemType VARCHAR(10) = '-function'
    , @VideosSystemPath NVARCHAR(255) = 'home.library.videos'
    , @LibrarySystemId INT
    , @LibrarySystemPath NVARCHAR(255) = 'home.library'
    , @StampDateTime DATETIME = GETUTCDATE()
    , @StampAction CHAR(1) = 'C'
    , @StampUser INT = 0
    , @ConcurrencyId INT = 1

/*
Summary
=================================================================
CRMPM-14001: Add new security items for new menu item Home -> Library -> Videos


DatabaseName        TableName                       Expected Rows
=================================================================
administration      TSystem                         1
administration      TSystemAudit                    1
*/


SELECT
    @ScriptGUID = 'E0736DAC-A0D9-4B44-8CB3-DAE36715CCC3',
    @Comments = 'CRMPM-14001: Add new security items for new menu item Home -> Library -> Videos'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

SET @LibrarySystemId = (SELECT [SystemId] FROM [dbo].[TSystem] WHERE [SystemPath] = @LibrarySystemPath)

BEGIN TRY

    BEGIN TRANSACTION

        IF NOT EXISTS (SELECT 1 FROM [dbo].[TSystem] WHERE [SystemPath] = @VideosSystemPath)
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
                (@VideosSystemIdentifier
                , @VideosSystemDescription
                , @VideosSystemPath
                , @VideosSystemType
                , @LibrarySystemId
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
