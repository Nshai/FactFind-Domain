USE [administration]


DECLARE @ScriptGUID UNIQUEIDENTIFIER
    , @Comments VARCHAR(255)
    , @VideosSystemId INT
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
administration      TRefLicenseTypeToSystem         3
administration      TRefLicenseTypeToSystemAudit    3
*/


SELECT
    @ScriptGUID = '68FFD484-4795-4432-8DAF-430E508751E9',
    @Comments = 'CRMPM-14001: Add new security items for new menu item Home -> Library -> Videos'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

SET @VideosSystemId = (SELECT [SystemId] FROM [dbo].[TSystem] WHERE [SystemPath] = @VideosSystemPath)
SET @LibrarySystemId = (SELECT [SystemId] FROM [dbo].[TSystem] WHERE [SystemPath] = @LibrarySystemPath)

BEGIN TRY

    BEGIN TRANSACTION

        IF NOT EXISTS (SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE [SystemId] = @VideosSystemId)
        BEGIN

            INSERT INTO [dbo].[TRefLicenseTypeToSystem]
                ([RefLicenseTypeId]
                , [SystemId]
                , [ConcurrencyId])
            OUTPUT
                INSERTED.[RefLicenseTypeToSystemId]
                , INSERTED.[RefLicenseTypeId]
                , INSERTED.[SystemId]
                , INSERTED.[ConcurrencyId]
                , @StampAction
                , @StampDateTime
                , @StampUser
            INTO [dbo].[TRefLicenseTypeToSystemAudit]
                ([RefLicenseTypeToSystemId]
                , [RefLicenseTypeId]
                , [SystemId]
                , [ConcurrencyId]
                , [StampAction]
                , [StampDateTime]
                , [StampUser])
            SELECT
                [RefLicenseTypeId]
                , @VideosSystemId
                , @ConcurrencyId
            FROM [dbo].[TRefLicenseTypeToSystem]
            WHERE SystemId = @LibrarySystemId

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
